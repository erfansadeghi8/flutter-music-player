import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

/// Owns the single [AudioPlayer] instance and all background-safe playlist
/// state. The UI SongController wraps this handler; it never creates its own
/// AudioPlayer.
class LyraAudioHandler extends BaseAudioHandler with SeekHandler {
  // ─── Single, permanent AudioPlayer ───────────────────────────────────────
  final AudioPlayer player = AudioPlayer();

  // ─── Background-resident playlist state ──────────────────────────────────
  // This list lives here so Next/Previous work even when the UI is closed.
  final List<SongModel> _playlist = [];
  int _currentIndex = 0;
  bool _isRandom = false;
  bool _isRepeat = false;
  bool _isChangingSong = false;
  final _random = Random();

  final _box = GetStorage();
  final _audioQuery = OnAudioQuery();

  StreamSubscription? _playerStateSub;

  // ─── UI callbacks (optional — the UI may rebind on resume) ───────────────
  // These are called after the handler has already executed the skip so the
  // UI stays in sync when it is open.
  void Function(int index)? onSongChanged;

  // ─── Constructor ─────────────────────────────────────────────────────────
  LyraAudioHandler() {
    // Mirror player events into the AudioService playback state stream.
    player.playbackEventStream.listen((_) => _broadcast(), onError: (_) => _broadcast());

    // Auto-advance when a track completes.
    _playerStateSub = player.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        if (_isRepeat) {
          final song = _currentSong;
          if (song != null) await _loadAndPlay(song, initialPosition: Duration.zero);
        } else {
          await _advanceNext();
        }
      }
    });

    _broadcast();
  }

  // ─── Playlist management ─────────────────────────────────────────────────

  /// Replaces the handler's internal playlist and sets the active index.
  void setPlaylist(List<SongModel> songs, {int startIndex = 0}) {
    _playlist
      ..clear()
      ..addAll(songs);
    _currentIndex = startIndex.clamp(0, songs.isEmpty ? 0 : songs.length - 1);
  }

  /// Updates the current track pointer without changing the list.
  void setCurrentIndex(int index) {
    if (_playlist.isEmpty) return;
    _currentIndex = index.clamp(0, _playlist.length - 1);
  }

  void setRandom(bool value) => _isRandom = value;
  void setRepeat(bool value) => _isRepeat = value;

  SongModel? get _currentSong =>
      _playlist.isEmpty ? null : _playlist[_currentIndex];

  int get currentIndex => _currentIndex;
  List<SongModel> get playlist => List.unmodifiable(_playlist);

  // ─── Internal playback helpers ───────────────────────────────────────────

  Future<void> _loadAndPlay(
    SongModel song, {
    Duration? initialPosition,
    bool shouldPlay = true,
  }) async {
    await _updateMediaItem(song);
    await player.setFilePath(song.data, initialPosition: initialPosition);
    if (shouldPlay) {
      unawaited(player.play());
    } else {
      await player.pause();
    }
  }

  Future<void> _advanceNext() async {
    if (_playlist.isEmpty || _isChangingSong) return;
    _isChangingSong = true;
    try {
      final wasPlaying = player.playing;
      final prev = _currentIndex;

      if (_isRandom && _playlist.length > 1) {
        int idx;
        do { idx = _random.nextInt(_playlist.length); } while (idx == prev);
        _currentIndex = idx;
      } else {
        _currentIndex = (_currentIndex + 1) % _playlist.length;
      }

      final song = _playlist[_currentIndex];
      await _box.write('savePostionSing', 0);
      await _box.write('last_id_song', song.id);
      onSongChanged?.call(_currentIndex);

      await _loadAndPlay(song, shouldPlay: wasPlaying);
    } catch (_) {
    } finally {
      _isChangingSong = false;
    }
  }

  Future<void> _advancePrev() async {
    if (_playlist.isEmpty || _isChangingSong) return;
    _isChangingSong = true;
    try {
      final wasPlaying = player.playing;
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
      final song = _playlist[_currentIndex];
      await _box.write('savePostionSing', 0);
      await _box.write('last_id_song', song.id);
      onSongChanged?.call(_currentIndex);

      await _loadAndPlay(song, shouldPlay: wasPlaying);
    } catch (_) {
    } finally {
      _isChangingSong = false;
    }
  }

  // ─── Notification / MediaItem ────────────────────────────────────────────

  void setCurrentMediaItem(MediaItem item) {
    mediaItem.add(item);
    _broadcast();
  }

  /// Updates the MediaItem metadata for [song], then asynchronously loads the
  /// artwork so the notification stays responsive.
  Future<void> _updateMediaItem(SongModel song) async {
    final item = MediaItem(
      id: song.data,
      title: song.title,
      artist: song.artist ?? 'Unknown Artist',
      album: song.album,
      duration: Duration(milliseconds: song.duration ?? 0),
    );
    mediaItem.add(item);
    _broadcast();

    // Load artwork in background — do not await.
    unawaited(_updateArtwork(song, item));
  }

  Future<void> _updateArtwork(SongModel song, MediaItem baseItem) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/art_${song.id}.jpg');
      if (!await file.exists()) {
        final bytes = await _audioQuery.queryArtwork(
          song.id,
          ArtworkType.AUDIO,
          format: ArtworkFormat.JPEG,
          size: 500,
        );
        if (bytes == null) return;
        await file.writeAsBytes(bytes);
      }
      // Guard: only update if the song is still the current one.
      if (_currentSong?.id == song.id) {
        mediaItem.add(baseItem.copyWith(artUri: file.uri));
      }
    } catch (_) {}
  }

  // ─── Playback state broadcast ─────────────────────────────────────────────

  void _broadcast() {
    final processingState = {
      ProcessingState.idle: AudioProcessingState.idle,
      ProcessingState.loading: AudioProcessingState.loading,
      ProcessingState.buffering: AudioProcessingState.buffering,
      ProcessingState.ready: AudioProcessingState.ready,
      ProcessingState.completed: AudioProcessingState.completed,
    }[player.processingState]!;

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: processingState,
        playing: player.playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
      ),
    );
  }

  // ─── BaseAudioHandler overrides ──────────────────────────────────────────

  @override
  Future<void> play() async => player.play();

  @override
  Future<void> pause() async => player.pause();

  @override
  Future<void> seek(Duration position) async => player.seek(position);

  @override
  Future<void> skipToNext() async => _advanceNext();

  @override
  Future<void> skipToPrevious() async => _advancePrev();

  @override
  Future<void> stop() async {
    await player.stop();
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
    await super.stop();
  }

  // Called by Android when the user swipes the app away from Recents.
  // If a media foreground service is active and playing, Android will NOT
  // call this until it decides to stop the service itself.
  // We only stop if the player is NOT playing — music continues otherwise.
  @override
  Future<void> onTaskRemoved() async {
    // Do not stop if currently playing — Android foreground service keeps us alive.
    if (!player.playing &&
        player.processingState != ProcessingState.buffering &&
        player.processingState != ProcessingState.loading) {
      await stop();
    }
  }

  // Called when the user explicitly dismisses the media notification.
  // This is an intentional stop.
  @override
  Future<void> onNotificationDeleted() async {
    await stop();
  }

  // ─── Clean-up ────────────────────────────────────────────────────────────

  /// Only call this when the entire audio service is truly shutting down.
  Future<void> disposeHandler() async {
    onSongChanged = null;
    await _playerStateSub?.cancel();
    _playerStateSub = null;
    await player.dispose();
  }
}
