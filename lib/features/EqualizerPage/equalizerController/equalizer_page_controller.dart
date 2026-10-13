// ignore_for_file: avoid_print, dead_null_aware_expression, dead_code

import 'package:get/get.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';

class EqualizerController extends GetxController {
  final SongController songController = Get.find<SongController>();
  final storage = Storage();
  var isEqEnabled = false.obs;
  var isReady = false.obs;
  var bandLevels = <int>[].obs;
  var centerFreqs = <int>[].obs;
  var presetNames = <String>[].obs;
  var minLevel = 0;
  var maxLevel = 0;
  int? sessionId;
  RxInt indexListEqualizer = 0.obs;
  RxMap<String, List<int>> equalizerPresets = <String, List<int>>{
    "Normal": [60000, 230000, 910000, 3600000, 14000000],
    "Pop": [80000, 200000, 500000, 2000000, 6000000],
    "Rock": [100000, 300000, 1000000, 4000000, 10000000],
    "Jazz": [60000, 180000, 700000, 3000000, 8000000],
    "Custom": [60000, 230000, 910000, 3600000, 14000000],
  }.obs;

  RxMap<String, List<int>> presetLevels = <String, List<int>>{
    'Normal': [0, 0, 0, 0, 0],
    'Pop': [2, 4, 1, 3, 2],
    'Rock': [5, 3, -2, 3, 5],
    'Jazz': [3, 1, -1, 2, 4],
    'Custom': [0, 0, 0, 0, 0],
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _connectToPlayer();
    isEqEnabled.value = storage.readIsOnEqualizer();
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
    try {
      print('Before EqualizerFlutter.init');
      // مهم:
      // await نمی‌کنیم چون init در دستگاه تو Future را کامل نمی‌کند.
      EqualizerFlutter.init(sessionId!);
      await Future.delayed(const Duration(milliseconds: 500));
      final range = await EqualizerFlutter.getBandLevelRange();
      if (range.length < 2) {
        return;
      }
      minLevel = range[0];
      maxLevel = range[1];
      final freqs = await EqualizerFlutter.getCenterBandFreqs();
      if (freqs.isEmpty) {
        return;
      }
      final levels = <int>[];
      for (int i = 0; i < freqs.length; i++) {
        try {
          final level = await EqualizerFlutter.getBandLevel(i);
          levels.add(level ?? 0);
        } catch (e) {
          levels.add(0);
        }
      }
      if (levels.length != freqs.length) {
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
    } catch (e, stackTrace) {
      print('ERROR: $e');
      print(stackTrace);
    }
  }

  Future<void> toggleEqualizer(bool value) async {
    isEqEnabled.value = value;
    await EqualizerFlutter.setEnabled(value);
  }

  Future<void> setBandLevel(int bandIndex, int level) async {
    if (bandIndex < 0 || bandIndex >= bandLevels.length) return;

    bandLevels[bandIndex] = level;
    bandLevels.refresh();

    indexListEqualizer.value = equalizerPresets.keys.toList().indexOf('Custom');

    presetLevels['Custom'] = bandLevels.toList();
    presetLevels.refresh();

    await EqualizerFlutter.setBandLevel(bandIndex, level);

    await storage.saveEqualizerPreset('Custom', bandLevels.toList());
  }

  Future<void> applyPreset(String presetName) async {
    final presetIndex = equalizerPresets.keys.toList().indexOf(presetName);

    if (presetIndex == -1) return;

    indexListEqualizer.value = presetIndex;

    if (presetName == 'Custom') {
      final saved = storage.readEqualizerPreset('Custom');

      final levels = saved ?? presetLevels['Custom'];

      if (levels == null) return;

      for (int i = 0; i < centerFreqs.length && i < levels.length; i++) {
        await EqualizerFlutter.setBandLevel(i, levels[i]);
        bandLevels[i] = levels[i];
      }

      bandLevels.refresh();
      presetLevels['Custom'] = bandLevels.toList();
      presetLevels.refresh();

      return;
    }

    await EqualizerFlutter.setPreset(presetName);

    for (int i = 0; i < centerFreqs.length; i++) {
      final level = await EqualizerFlutter.getBandLevel(i);
      bandLevels[i] = level ?? 0;
    }

    bandLevels.refresh();
    presetLevels[presetName] = bandLevels.toList();

    await storage.saveEqualizerPreset(presetName, bandLevels.toList());
  }

  Future<void> resetToFlat() async {
    for (int i = 0; i < centerFreqs.length; i++) {
      await setBandLevel(i, 0);
    }
  }

  @override
  void onClose() {
    // EqualizerFlutter.release();
    super.onClose();
  }
}
