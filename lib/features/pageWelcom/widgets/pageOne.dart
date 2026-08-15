// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/theme/themeCustomer.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';

class Pageone extends StatelessWidget {
  Pageone({super.key});
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
              "assets/imageWelcome/backgroundHomeScreen.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 400,
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
              width: 190,
              child: Text(
                textAlign: TextAlign.center,
                "Enjoy Your Favorite Music",
                style: Theme.of(context).copyWith().textTheme.displayMedium,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSize.sizebetweentexts),
        //text
        Opacity(
          opacity: controller.opacetyColunm.value,
          child: Transform.translate(
            offset: Offset(0, controller.transleatcolunmText.value),
            child: SizedBox(
              width: 210,
              child: Text(
                textAlign: TextAlign.center,
                "All Your songs , anytime anywhere.",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
        ),
        SizedBox.shrink(),
      ],
    );
  }
}
