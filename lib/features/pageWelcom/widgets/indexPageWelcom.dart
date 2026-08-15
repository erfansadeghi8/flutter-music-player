import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';

class Indexpagewelcom extends StatelessWidget {
  Indexpagewelcom({super.key});
  final Pagewelcomcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    //This section is for the slider, which fills the empty circle cells by changing the index.
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: controller.pageIndex.value == 1
                  ? ColorSlaider.backgroundColorSlaiderWelcommPageSelected
                  : ColorSlaider.backgroundColorSlaiderWelcommPageNotSelected,
              borderRadius: BorderRadius.circular(AppSize.circular),
            ),
          ),
          SizedBox(width: AppSize.sizebetweentexts),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: controller.pageIndex.value == 2
                  ? ColorSlaider.backgroundColorSlaiderWelcommPageSelected
                  : ColorSlaider.backgroundColorSlaiderWelcommPageNotSelected,
              borderRadius: BorderRadius.circular(AppSize.circular), //50
            ),
          ),
          SizedBox(width: AppSize.sizebetweentexts),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: controller.pageIndex.value == 3
                  ? ColorSlaider.backgroundColorSlaiderWelcommPageSelected
                  : ColorSlaider.backgroundColorSlaiderWelcommPageNotSelected,
              borderRadius: BorderRadius.circular(AppSize.circular),
            ),
          ),
        ],
      );
    });
  }
}
