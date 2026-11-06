
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class LyraAudioHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayer? _player;

  Future<void> Function()? _onNext;
  Future<void> Function()? _onPrev;
  Future<void> Function()? _onPause;

  bool _keepSessionActive = false;

  StreamSubscription? _playbackSubscription;
  StreamSubscription? _playingSubscription;

  Future<void> attach(
    AudioPlayer player, {
    required Future<void> Function() onNext,
    required Future<void> Function() onPrev,
    required Future<void> Function() onPause,
  }) async {
    _player = player;

    _onNext = onNext;
    _onPrev = onPrev;
    _onPause = onPause;

    await _playbackSubscription?.cancel();
    await _playingSubscription?.cancel();

    _playbackSubscription =
        player.playbackEventStream.listen(
      (_) => _broadcast(),
      onError: (_) => _broadcast(),
    );

    _playingSubscription =
        player.playingStream.listen((playing) {
      if (playing) {
        _keepSessionActive = false;
      }
      _broadcast();
    });

    _broadcast();
  }

  void _broadcast() {
    final p = _player;
    if (p == null) return;

    final state = p.processingState;

    final processingState = {
      ProcessingState.idle: AudioProcessingState.idle,
      ProcessingState.loading: AudioProcessingState.loading,
      ProcessingState.buffering: AudioProcessingState.buffering,
      ProcessingState.ready: AudioProcessingState.ready,
      ProcessingState.completed: AudioProcessingState.completed,
    }[state]!;

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          (p.playing || _keepSessionActive)
              ? MediaControl.pause
              : MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: processingState,
        playing: p.playing || _keepSessionActive,
        updatePosition: p.position,
        bufferedPosition: p.bufferedPosition,
        speed: p.speed,
      ),
    );
  }

  // ثبت اطلاعات آهنگ جدید
  void setCurrentMediaItem(MediaItem item) {
    mediaItem.add(item);
    _broadcast();
  }

  @override
  Future<void> play() async {
    final p = _player;
    if (p == null) return;

    _keepSessionActive = true;
    _broadcast();

    unawaited(p.play());
  }

  @override
  Future<void> pause() async {
    _keepSessionActive = false;

    if (_onPause != null) {
      await _onPause!();
    } else {
      await _player?.pause();
    }

    _broadcast();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player?.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    final wasPlaying = _player?.playing ?? false;

    _keepSessionActive = wasPlaying;
    _broadcast();

    try {
      await _onNext?.call();
    } catch (e) {
      _keepSessionActive = false;
      _broadcast();
      rethrow;
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final wasPlaying = _player?.playing ?? false;

    _keepSessionActive = wasPlaying;
    _broadcast();

    try {
      await _onPrev?.call();
    } catch (e) {
      _keepSessionActive = false;
      _broadcast();
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    _keepSessionActive = false;

    await _player?.pause();

    await super.stop();
  }

  Future<void> disposeHandler() async {
    await _playbackSubscription?.cancel();
    await _playingSubscription?.cancel();
  }
}

late LyraAudioHandler lyraHandler;
