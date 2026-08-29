import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/widgets/music_animation_widget/music_animation_widget_controller/music_animation_widget_controller.dart';

class MusicAnimationWidget extends StatelessWidget {
  const MusicAnimationWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MusicAnimationWidgetController());

    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: controller.bars.map((height) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 5,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }).toList(),
      );
    });
  }
}
