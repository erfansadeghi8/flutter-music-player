import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';

class Pagetwo extends StatelessWidget {
  Pagetwo({super.key});
  final Pagewelcomcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        //The first photo is for me.
        Opacity(
          opacity: controller.opacetyColunm.value,
          child: Transform.translate(
            offset: Offset(0, controller.transleatcolunmImage.value),
            child: Image.asset(
              "assets/imageWelcome/pageWellcom2.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
          ),
        ),
        SizedBox(height: 30),
        //text
        Opacity(
          opacity: controller.opacetyColunm.value,
          child: Transform.translate(
            offset: Offset(0, controller.transleatcolunmText.value),
            child: SizedBox(
              width: 190,
              child: Text(
                textAlign: TextAlign.center,
                "Enjoy Every Beat",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        //text
        Opacity(
          opacity: controller.opacetyColunm.value,
          child: Transform.translate(
            offset: Offset(0, controller.transleatcolunmText.value),
            child: SizedBox(
              width: 210,
              child: Text(
                textAlign: TextAlign.center,
                "Play your favorite songs with a smooth, powerful, and immersive music experience.",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
