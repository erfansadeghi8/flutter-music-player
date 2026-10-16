import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/features/EqualizerPage/equalizerController/equalizer_page_controller.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';

class EqualizerPage extends StatelessWidget {
  EqualizerPage({super.key});
  final EqualizerController controller = Get.put(EqualizerController());
  final SongController songController = Get.put(SongController());

  @override
  Widget build(BuildContext context) {
    final presets = controller.equalizerPresets.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Equalizer')),
      body: Obx(() {
        if (controller.centerFreqs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Equalizer'),
              value: controller.isEqEnabled.value,
              onChanged: (value) async {
                await controller.storage.saveIsOnEqulauzer(value);
                await controller.toggleEqualizer(value);
              },
            ),
            Expanded(
              child: Row(
                children: List.generate(controller.centerFreqs.length, (i) {
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: SliderTheme(
                              data: SliderThemeData(
                                thumbColor: Colors.lightBlue,
                                activeTrackColor: Colors.lightBlue,
                                inactiveTrackColor: Colors.lightBlue.shade100,
                                overlayColor: Colors.lightBlue.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              child: Slider(
                                min: controller.minLevel.toDouble(),
                                max: controller.maxLevel.toDouble(),
                                value: controller.bandLevels[i].toDouble(),
                                onChanged: controller.isEqEnabled.value
                                    ? (v) {
                                        controller.setBandLevel(i, v.toInt());
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        Text('${controller.bandLevels[i]} dB'),
                      ],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(presets.length, (index) {
                    final presetsName = presets[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: InkWell(
                        onTap: controller.isEqEnabled.value
                            ? () async {
                                controller.indexListEqualizer.value = index;
                                final a = controller
                                    .equalizerPresets[presetsName]
                                    ?.toList();
                                final b = controller.presetLevels[presetsName]
                                    ?.toList();
                                controller.centerFreqs.assignAll(a ?? []);
                                controller.bandLevels.assignAll(b ?? []);
                                await controller.applyPreset(presetsName);
                              }
                            : null,
                        child: Container(
                          width: 60,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: controller.indexListEqualizer.value == index
                                ? const Color.fromARGB(255, 9, 106, 151)
                                : const Color.fromARGB(255, 75, 75, 75),
                          ),
                          child: Center(
                            child: Text(
                              presetsName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("volum"),
                      SliderTheme(
                        data: SliderThemeData(
                          thumbColor: Colors.lightBlue,
                          activeTrackColor: Colors.lightBlue,
                          inactiveTrackColor: Colors.lightBlue.shade100,
                          overlayColor: Colors.lightBlue.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          min: 0,
                          max: 100,
                          value: songController.valueVolum.value,
                          onChanged: (value) {
                            songController.valueVolum.value = value;
                            songController.audioPlayer.setVolume(value / 100);
                          },
                        ),
                      ),
                      Text("${songController.valueVolum.value.toInt()}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("speed"),
                      SliderTheme(
                        data: SliderThemeData(
                          thumbColor: Colors.lightBlue,
                          activeTrackColor: Colors.lightBlue,
                          inactiveTrackColor: Colors.lightBlue.shade100,
                          overlayColor: Colors.lightBlue.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          min: 0.25,
                          max: 4,
                          value: songController.speedSongValue.value,
                          onChanged: (value) {
                            songController.speedSongValue.value = value;
                            songController.audioPlayer.setSpeed(value);
                          },
                        ),
                      ),
                      Text(
                        "${songController.speedSongValue.value.toStringAsFixed(2)}x",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
