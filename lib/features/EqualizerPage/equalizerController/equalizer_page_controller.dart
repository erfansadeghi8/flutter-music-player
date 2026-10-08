// ignore_for_file: avoid_print, dead_null_aware_expression, dead_code

import 'package:get/get.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';

class EqualizerController extends GetxController {
  final SongController songController = Get.find<SongController>();

  var isEqEnabled = false.obs;
  var isReady = false.obs;
  var bandLevels = <int>[].obs;
  var centerFreqs = <int>[].obs;
  var presetNames = <String>[].obs;
  var minLevel = 0;
  var maxLevel = 0;
  int? sessionId;

  @override
  void onInit() {
    super.onInit();
    _connectToPlayer();
  }

  Future<void> _connectToPlayer() async {
    sessionId = songController.audioPlayer.androidAudioSessionId;
    if (sessionId != null) {
      await _setupEqualizer();
      return;
    }
    songController.audioPlayer.playerStateStream.listen((state) async {
      if (state.playing && sessionId == null) {
        sessionId = songController.audioPlayer.androidAudioSessionId;
        if (sessionId != null) {
          await _setupEqualizer();
        }
      }
    });
  }

  Future<void> _setupEqualizer() async {
    if (sessionId == null) {
      print('❌ Session ID is null');
      return;
    }

    print('========== SETUP EQUALIZER ==========');
    print('Session ID: $sessionId');

    try {
      print('Before EqualizerFlutter.init');

      // مهم:
      // await نمی‌کنیم چون init در دستگاه تو Future را کامل نمی‌کند.
      EqualizerFlutter.init(sessionId!);

      await Future.delayed(const Duration(milliseconds: 500));

      print('After EqualizerFlutter.init');

      final range = await EqualizerFlutter.getBandLevelRange();

      print('Range: $range');

      if (range.length < 2) {
        print('❌ Invalid range');
        return;
      }

      minLevel = range[0];
      maxLevel = range[1];

      final freqs = await EqualizerFlutter.getCenterBandFreqs();

      print('Frequencies: $freqs');

      if (freqs.isEmpty) {
        print('❌ Frequencies empty');
        return;
      }

      final levels = <int>[];

      for (int i = 0; i < freqs.length; i++) {
        try {
          final level = await EqualizerFlutter.getBandLevel(i);

          print('Band $i = $level');

          levels.add(level ?? 0);
        } catch (e) {
          print('Band $i error: $e');

          levels.add(0);
        }
      }

      print('Levels: $levels');

      if (levels.length != freqs.length) {
        print(
          '❌ Mismatch: '
          '${levels.length} levels / '
          '${freqs.length} frequencies',
        );

        return;
      }

      bandLevels.assignAll(levels);
      centerFreqs.assignAll(freqs);

      try {
        final presets = await EqualizerFlutter.getPresetNames();

        presetNames.assignAll(presets);

        print('Presets: $presets');
      } catch (e) {
        print('Preset error: $e');
      }

      isReady.value = true;

      print('========== EQ READY ==========');
    } catch (e, stackTrace) {
      print('========== EQ ERROR ==========');
      print('ERROR: $e');
      print(stackTrace);
    }
  }

  Future<void> toggleEqualizer(bool value) async {
    isEqEnabled.value = value;
    await EqualizerFlutter.setEnabled(value);
  }

  Future<void> setBandLevel(int bandIndex, int level) async {
    bandLevels[bandIndex] = level;
    bandLevels.refresh();
    await EqualizerFlutter.setBandLevel(bandIndex, level);
  }

  Future<void> applyPreset(String presetName) async {
    await EqualizerFlutter.setPreset(presetName);
    for (int i = 0; i < centerFreqs.length; i++) {
      final level = await EqualizerFlutter.getBandLevel(i);
      bandLevels[i] = level ?? 0;
    }
    bandLevels.refresh();
  }

  Future<void> resetToFlat() async {
    for (int i = 0; i < centerFreqs.length; i++) {
      await setBandLevel(i, 0);
    }
  }

  @override
  void onClose() {
    EqualizerFlutter.release();
    super.onClose();
  }
}
