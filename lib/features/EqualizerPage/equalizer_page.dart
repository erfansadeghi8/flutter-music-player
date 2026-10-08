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
    return Scaffold(
      appBar: AppBar(title: const Text('اکولایزر')),
      body: Obx(() {
        if (controller.centerFreqs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            SwitchListTile(
              title: const Text('فعال‌سازی اکولایزر'),
              value: controller.isEqEnabled.value,
              onChanged: controller.toggleEqualizer,
            ),
            Expanded(
              child: Row(
                children: List.generate(controller.centerFreqs.length, (i) {
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              min: controller.minLevel.toDouble(),
                              max: controller.maxLevel.toDouble(),
                              value: controller.bandLevels[i].toDouble(),
                              onChanged: (v) =>
                                  controller.setBandLevel(i, v.toInt()),
                            ),
                          ),
                        ),
                        Text('${controller.centerFreqs[i] ~/ 1000}Hz'),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}
