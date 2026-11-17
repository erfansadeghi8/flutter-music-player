// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/lyra_audio_handler.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/data/models/folder_mode.dart';
import 'package:music_player/data/models/model_favorite_songs.dart';
import 'package:music_player/data/models/model_recently_song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SongController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();

  final songs = <SongModel>[].obs;
  final songRecently = <SongModel>[].obs;
  final songRecentlyStorage = <ModelRecentlySong>[].obs;
  final favoriteSongs = <ModelFavoriteSongs>[].obs;

  final storage = Storage();

  // ── Single shared AudioPlayer owned by LyraAudioHandler ──────────────────
  LyraAudioHandler get lyraHandler => Get.find<LyraAudioHandler>();
  AudioPlayer get audioPlayer => lyraHandler.player;

  final Rxn<SongModel> currentSong = Rxn<SongModel>();
  final Rxn<SongModel> nextAndBackSongMusic = Rxn<SongModel>();

  // ── Playlist state lives in LyraAudioHandler (background-safe). ──────────
  // These Rx mirrors exist only for UI reactivity.
  final RxList<SongModel> currentPlaylist = <SongModel>[].obs;
  final RxInt currentPlaylistIndex = 0.obs;

  final friesTime = Duration().obs;
  final tottalTime = Duration().obs;

  final randoIndex = Random();

  RxBool isplay = false.obs;
  RxInt nextIndex = 0.obs;
  RxInt backIndex = 0.obs;

  RxBool isRepet = false.obs;
  RxBool isrendom = false.obs;

  int get randomnInt => randoIndex.nextInt(songs.isNotEmpty ? songs.length : 1);

  RxDouble valueVolum = 50.0.obs;
  RxDouble speedSongValue = 1.0.obs;

  RxList savepositsionlist = [].obs;
  bool isChangingSong = false;

  final Map<int, Uint8List?> _artCache = {};
  final Rxn<Uint8List?> currentArt = Rxn<Uint8List?>();

  final RxList<FolderMode> foders = <FolderMode>[].obs;

  // ── Playlist helpers ──────────────────────────────────────────────────────

  void setCurrentPlaylist(List<SongModel> playlist, {int startIndex = 0}) {
    currentPlaylist.assignAll(playlist);
    final clamped = startIndex.clamp(0, playlist.isEmpty ? 0 : playlist.length - 1);
    currentPlaylistIndex.value = clamped;
    // Sync to handler so background Next/Prev uses the same list.
    lyraHandler.setPlaylist(playlist, startIndex: clamped);
  }

  void clearCurrentPlaylist() {
    currentPlaylist.clear();
    currentPlaylistIndex.value = 0;
    // Sync handler to global songs list.
    lyraHandler.setPlaylist(songs, startIndex: _globalIndex);
  }

  List<SongModel> get effectivePlaylist =>
      currentPlaylist.isEmpty ? songs : currentPlaylist;

  int get effectiveIndex => currentPlaylist.isEmpty
      ? _globalIndex
      : currentPlaylistIndex.value;

  int get _globalIndex =>
      songs.indexWhere((s) => s.id == currentSong.value?.id);

  // ── Permissions & Load Songs ──────────────────────────────────────────────

  Future<bool> checkAndRequestPermissions() async {
    if (!Platform.isAndroid) return true;

    if (await Permission.audio.isGranted || await Permission.storage.isGranted) {
      return true;
    }

    final audioStatus = await Permission.audio.request();
    if (audioStatus.isGranted) return true;

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<void> loadSongs() async {
    final permission = await checkAndRequestPermissions();
    if (!permission) return;
    try {
      final result = await audioQuery.querySongs();
      songs.assignAll(result);
      getFolder();
      // Seed the handler's playlist with all songs so background next/prev
      // has something to work with even before the user picks a playlist.
      lyraHandler.setPlaylist(songs, startIndex: 0);
    } catch (_) {}
  }

  // ── Recently & Folders ────────────────────────────────────────────────────

  void getFolder() {
    final Map<String, List<SongModel>> foldermap = {};

    for (final song in songs) {
      final path = song.data.replaceAll("\\", "/");
      final lastSlash = path.lastIndexOf("/");
      if (lastSlash == -1) continue;
      final folderPath = path.substring(0, lastSlash);

      foldermap.putIfAbsent(folderPath, () => []);
      foldermap[folderPath]!.add(song);
    }

    foders.assignAll(
      foldermap.entries.map((entry) {
        final path = entry.key;
        return FolderMode(
          name: path.substring(path.lastIndexOf("/") + 1),
          path: path,
          songs: entry.value,
        );
      }).toList(),
    );
  }

  void saveRecentlyGetstorage() {
    final date = songRecentlyStorage.map((song) => song.toJson()).toList();
    storage.saveReently(date);
  }

  void loadRecentlySong() {
    final readData = storage.readSaveRecentlySong();
    final recentlyList = readData.map((song) => ModelRecentlySong.fromJson(song)).toList();
    final oldLength = recentlyList.length;

    recentlyList.removeWhere(
      (song) => DateTime.now().difference(song.lastPlayedAt) >= const Duration(days: 30),
    );

    songRecentlyStorage.assignAll(recentlyList);

    if (oldLength != recentlyList.length) {
      saveRecentlyGetstorage();
    }
  }

  void addRecentlySong(int id) {
    final isExist = songRecentlyStorage.any((song) => song.songId == id);

    if (isExist) {
      final date = songRecentlyStorage.firstWhere((e) => e.songId == id);
      date.lastPlayedAt = DateTime.now();
    } else {
      songRecentlyStorage.add(ModelRecentlySong(songId: id, lastPlayedAt: DateTime.now()));
    }

    saveRecentlyGetstorage();
    updateRecentlySong();
    sortRecentlySongs();
  }

  void updateRecentlySong() {
    final date = songs.where(
      (song) => songRecentlyStorage.any((r) => r.songId == song.id),
    ).toList();
    songRecently.assignAll(date);
  }

  Future<void> loadFavoriteSongs() async {
    final data = storage.readFavoriteSongsList();
    final favoriteList = data.map((s) => ModelFavoriteSongs.fromJson(s)).toList();
    favoriteSongs.assignAll(favoriteList);
  }

  Future<void> loadRecentlyData() async {
    await loadSongs();
    await loadFavoriteSongs();

    loadRecentlySong();
    updateRecentlySong();

    if (songRecently.isNotEmpty) {
      final latestSong = songRecentlyStorage.reduce(
        (a, b) => a.lastPlayedAt.isAfter(b.lastPlayedAt) ? a : b,
      );

      final currentIndex = songs.indexWhere((s) => s.id == latestSong.songId);
      if (currentIndex >= 0) {
        currentSong.value = songs[currentIndex];
        // Seed handler index to the last-played song.
        lyraHandler.setCurrentIndex(currentIndex);
      }
    }
  }

  // ── Play ──────────────────────────────────────────────────────────────────

  Future<void> playeMusic(String urlmusic) async {
    if (urlmusic.isEmpty) return;

    final selectedSong = songs.firstWhereOrNull((s) => s.data == urlmusic);
    if (selectedSong != null) {
      currentSong.value = selectedSong;
    }

    final song = currentSong.value;
    if (song == null) return;

    // Update handler playlist index to this song.
    final handlerList = lyraHandler.playlist;
    final handlerIdx = handlerList.indexWhere((s) => s.id == song.id);
    if (handlerIdx >= 0) {
      lyraHandler.setCurrentIndex(handlerIdx);
    }

    // Update playlist index mirror for UI.
    if (currentPlaylist.isNotEmpty) {
      final idx = currentPlaylist.indexWhere((s) => s.id == song.id);
      if (idx >= 0) currentPlaylistIndex.value = idx;
    }

    // Resume from saved position only when reopening the same song.
    final lastPos = storage.box.read("savePostionSing");
    final lastId = storage.box.read("last_id_song");
    Duration? initial;
    if (lastId == song.id && lastPos != null && lastPos > 0) {
      initial = Duration(milliseconds: lastPos);
    }

    await _updateNotification();

    try {
      await audioPlayer.setFilePath(urlmusic, initialPosition: initial);
      isplay.value = true;
      unawaited(audioPlayer.play());
    } catch (e) {
      isplay.value = false;
      rethrow;
    }
  }

  // ── Pause ─────────────────────────────────────────────────────────────────

  Future<void> pussMusic() async {
    await audioPlayer.pause();
    saveCurrentPostion();
    isplay.value = false;
  }

  // ── Internal song switch (UI-initiated) ───────────────────────────────────

  Future<void> _switchToSong(SongModel song) async {
    final wasPlaying = audioPlayer.playing || isplay.value;

    currentSong.value = song;
    nextAndBackSongMusic.value = song;

    // Update handler index.
    final handlerList = lyraHandler.playlist;
    final handlerIdx = handlerList.indexWhere((s) => s.id == song.id);
    if (handlerIdx >= 0) lyraHandler.setCurrentIndex(handlerIdx);

    if (currentPlaylist.isNotEmpty) {
      final idx = currentPlaylist.indexWhere((s) => s.id == song.id);
      if (idx >= 0) currentPlaylistIndex.value = idx;
    }

    await storage.box.write("savePostionSing", 0);
    await storage.box.write("last_id_song", song.id);
    addRecentlySong(song.id);

    await _updateNotification();

    try {
      await audioPlayer.setFilePath(song.data);

      if (currentSong.value?.id != song.id) return;

      if (wasPlaying) {
        isplay.value = true;
        unawaited(audioPlayer.play());
      } else {
        isplay.value = false;
        await audioPlayer.pause();
      }
    } catch (e) {
      isplay.value = false;
      rethrow;
    }
  }

  // ── Next / Previous (UI-initiated) ───────────────────────────────────────
  // These are called from the UI only. The actual background-safe skip logic
  // lives in LyraAudioHandler._advanceNext / _advancePrev and is called by
  // the handler's skipToNext / skipToPrevious overrides.

  Future<void> nextSong() async {
    final playlist = effectivePlaylist;
    if (playlist.isEmpty || isChangingSong) return;

    isChangingSong = true;

    try {
      final currentIndex = effectiveIndex;
      if (currentIndex == -1) return;

      int newIndex;
      if (isrendom.value && playlist.length > 1) {
        do { newIndex = randoIndex.nextInt(playlist.length); } while (newIndex == currentIndex);
      } else {
        newIndex = (currentIndex + 1) % playlist.length;
      }

      nextIndex.value = newIndex;
      await _switchToSong(playlist[newIndex]);
    } catch (e) {
      isplay.value = false;
    } finally {
      isChangingSong = false;
    }
  }

  Future<void> backSong() async {
    final playlist = effectivePlaylist;
    if (playlist.isEmpty || isChangingSong) return;

    isChangingSong = true;

    try {
      final currentIndex = effectiveIndex;
      if (currentIndex == -1) return;

      backIndex.value = (currentIndex - 1 + playlist.length) % playlist.length;
      await _switchToSong(playlist[backIndex.value]);
    } finally {
      isChangingSong = false;
    }
  }

  // ── Player listeners ──────────────────────────────────────────────────────

  void initplayer() {
    isplay.value = audioPlayer.playing;

    audioPlayer.positionStream.listen((position) {
      friesTime.value = position;
    });

    audioPlayer.durationStream.listen((duration) {
      if (duration != null) tottalTime.value = duration;
    });

    // Sync isplay from actual player state.
    // Song completion / auto-advance is handled inside LyraAudioHandler's
    // playerStateStream listener so it works in the background too.
    audioPlayer.playerStateStream.listen((state) {
      isplay.value = state.playing;
    });

    // When the handler advances a song in the background, sync UI state.
    lyraHandler.onSongChanged = (index) {
      final list = lyraHandler.playlist;
      if (index < 0 || index >= list.length) return;
      final song = list[index];
      currentSong.value = song;
      nextAndBackSongMusic.value = song;
      currentPlaylistIndex.value = index;
      addRecentlySong(song.id);
    };
  }

  // ── Favorites ─────────────────────────────────────────────────────────────

  Future<void> toggleFavorite(int songid) async {
    final index = favoriteSongs.indexWhere((s) => s.songId == songid);
    if (index >= 0) {
      favoriteSongs.removeAt(index);
    } else {
      favoriteSongs.add(ModelFavoriteSongs(isFavorite: true, songId: songid));
    }
    await saveToFavorite();
  }

  Future<void> saveToFavorite() async {
    final data = favoriteSongs.map((s) => s.toJson()).toList();
    await storage.saveFavorite(data);
  }

  // ── Volume / Speed ────────────────────────────────────────────────────────

  Future<void> volumSong() async => audioPlayer.setVolume(valueVolum.value);
  Future<void> speedSong() async => audioPlayer.setSpeed(speedSongValue.value);

  // ── Position ──────────────────────────────────────────────────────────────

  Future<void> saveCurrentPostion() async {
    final position = audioPlayer.position;
    if (currentSong.value != null) {
      await storage.box.write("savePostionSing", position.inMilliseconds);
      await storage.box.write("last_id_song", currentSong.value!.id);
    }
  }

  Future<void> resetCurrentPostion() async {
    if (currentSong.value != null) {
      await storage.box.write("savePostionSing", 0);
      await storage.box.write("last_id_song", currentSong.value!.id);
    }
  }

  // ── Artwork helpers ───────────────────────────────────────────────────────

  Future<Uint8List?> _loadArtwork(SongModel song) async {
    if (_artCache.containsKey(song.id)) return _artCache[song.id];
    try {
      final bytes = await audioQuery.queryArtwork(
        song.id,
        ArtworkType.AUDIO,
        size: 500,
        quality: 85,
      );
      if (_artCache.length > 50) _artCache.remove(_artCache.keys.first);
      _artCache[song.id] = bytes;
      return bytes;
    } catch (_) {
      return null;
    }
  }

  void sortRecentlySongs() {
    songRecently.sort((a, b) {
      final recordA = songRecentlyStorage.firstWhereOrNull((i) => i.songId == a.id);
      final recordB = songRecentlyStorage.firstWhereOrNull((i) => i.songId == b.id);
      final timeA = recordA?.lastPlayedAt;
      final timeB = recordB?.lastPlayedAt;
      if (timeA == null && timeB == null) return 0;
      if (timeA == null) return 1;
      if (timeB == null) return -1;
      return timeB.compareTo(timeA);
    });
    songRecently.refresh();
  }

  // ── onInit ────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    initplayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadRecentlyData();
    });

    ever(currentSong, (song) async {
      if (song == null) return;
      final bytes = await _loadArtwork(song);
      if (currentSong.value?.id == song.id) {
        currentArt.value = bytes;
      }
      _preloadNeighbors();
    });

    // Keep handler random/repeat flags in sync.
    ever(isrendom, (val) => lyraHandler.setRandom(val));
    ever(isRepet, (val) => lyraHandler.setRepeat(val));
  }

  // ── Notification ──────────────────────────────────────────────────────────

  Future<Uri?> _saveArtwork(SongModel song) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/art_${song.id}.jpg');
      if (!await file.exists()) {
        final bytes = await audioQuery.queryArtwork(
          song.id,
          ArtworkType.AUDIO,
          format: ArtworkFormat.JPEG,
          size: 500,
        );
        if (bytes == null) return null;
        await file.writeAsBytes(bytes);
      }
      return file.uri;
    } catch (_) {
      return null;
    }
  }

  Future<void> _updateNotification() async {
    final song = currentSong.value;
    if (song == null) return;

    final item = MediaItem(
      id: song.data,
      title: song.title,
      artist: song.artist ?? 'Unknown Artist',
      album: song.album,
      duration: audioPlayer.duration ?? Duration(milliseconds: song.duration ?? 0),
    );
    lyraHandler.setCurrentMediaItem(item);
    unawaited(_updateArtwork(song, item));
  }

  Future<void> _updateArtwork(SongModel song, MediaItem item) async {
    try {
      final artworkUri = await _saveArtwork(song);
      if (artworkUri == null) return;
      if (currentSong.value?.id != song.id) return;
      lyraHandler.setCurrentMediaItem(item.copyWith(artUri: artworkUri));
    } catch (_) {}
  }

  void _preloadNeighbors() {
    final i = songs.indexWhere((s) => s.id == currentSong.value?.id);
    if (i == -1) return;
    for (final j in [i - 1, i + 1]) {
      if (j >= 0 && j < songs.length) _loadArtwork(songs[j]);
    }
  }

  // ── onClose ───────────────────────────────────────────────────────────────

  @override
  void onClose() {
    // Save position but do NOT stop/dispose the player or the audio service.
    unawaited(saveCurrentPostion());
    // Detach the UI callback so stale references don't leak.
    lyraHandler.onSongChanged = null;
    super.onClose();
  }
}
