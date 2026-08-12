import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';

class Pagetwo extends StatelessWidget {
  Pagetwo({super.key});
  final Pagewelcomcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(height: 20),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox.shrink(),
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
                style: TextStyle(
                  color: const Color.fromARGB(255, 126, 126, 126),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
