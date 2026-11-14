import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class LyraAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer player = AudioPlayer();

  Future<void> Function()? _onNext;
  Future<void> Function()? _onPrev;
  Future<void> Function()? _onPause;

  StreamSubscription? _playbackSubscription;
  StreamSubscription? _playingSubscription;

  bool _keepSessionActive = false;

  LyraAudioHandler() {
    _initPlayerListeners();
  }

  void _initPlayerListeners() {
    _playbackSubscription = player.playbackEventStream.listen(
      (_) => _broadcast(),
      onError: (_) => _broadcast(),
    );

    _playingSubscription = player.playingStream.listen((playing) {
      if (playing) {
        _keepSessionActive = false;
      }
      _broadcast();
    });

    _broadcast();
  }

  void registerCallbacks({
    Future<void> Function()? onNext,
    Future<void> Function()? onPrev,
    Future<void> Function()? onPause,
  }) {
    _onNext = onNext;
    _onPrev = onPrev;
    _onPause = onPause;
  }

  void _broadcast() {
    final state = player.processingState;

    final processingState = {
      ProcessingState.idle: AudioProcessingState.idle,
      ProcessingState.loading: AudioProcessingState.loading,
      ProcessingState.buffering: AudioProcessingState.buffering,
      ProcessingState.ready: AudioProcessingState.ready,
      ProcessingState.completed: AudioProcessingState.completed,
    }[state] ?? AudioProcessingState.idle;

    final isPlaying = player.playing || _keepSessionActive;

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          isPlaying ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: processingState,
        playing: isPlaying,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
      ),
    );
  }

  void setCurrentMediaItem(MediaItem item) {
    mediaItem.add(item);
    _broadcast();
  }

  @override
  Future<void> play() async {
    _keepSessionActive = false;
    await player.play();
    _broadcast();
  }

  @override
  Future<void> pause() async {
    _keepSessionActive = false;

    if (_onPause != null) {
      await _onPause!();
    } else {
      await player.pause();
    }

    _broadcast();
  }

  @override
  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    if (_onNext != null) {
      await _onNext!();
    }
    _broadcast();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_onPrev != null) {
      await _onPrev!();
    }
    _broadcast();
  }

  @override
  Future<void> stop() async {
    _keepSessionActive = false;
    await player.pause();
    await super.stop();
  }

  @override
  Future<void> onTaskRemoved() async {
    // هنگام بسته شدن صفحه برنامه‌های اخیر،
    // اگر موسیقی در حال پخش است، آن را متوقف نکن.
    if (!player.playing) {
      await stop();
    }
  }

  @override
  Future<void> onNotificationDeleted() async {
    await stop();
  }

  Future<void> disposeHandler() async {
    await _playbackSubscription?.cancel();
    await _playingSubscription?.cancel();
    await player.dispose();
  }
}
