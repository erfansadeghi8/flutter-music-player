import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
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
                  ? const Color.fromARGB(255, 151, 23, 211)
                  : const Color.fromARGB(137, 168, 168, 168),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: controller.pageIndex.value == 2
                  ? const Color.fromARGB(255, 151, 23, 211)
                  : const Color.fromARGB(137, 168, 168, 168),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: controller.pageIndex.value == 3
                  ? const Color.fromARGB(255, 151, 23, 211)
                  : const Color.fromARGB(137, 168, 168, 168),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ],
      );
    });
  }
}
