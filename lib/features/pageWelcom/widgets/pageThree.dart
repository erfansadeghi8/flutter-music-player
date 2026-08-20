// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';

class Pagethree extends StatelessWidget {
  Pagethree({super.key});
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
              "assets/imageWelcome/pageThreeImage.png",
              width: double.infinity,
              height: 300,
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
              width: 190,
              child: Text(
                textAlign: TextAlign.center,
                "Welcome to lyra",
                style: Theme.of(context).textTheme.displayMedium,
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
              width: 205,
              child: Text(
                textAlign: TextAlign.center,
                "Play your local music early and enjoy the best experience",
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
        ),
        // SizedBox(height: 10),
        //TextFormField for name
        Transform.translate(
          offset: Offset(0, controller.transleatcolunmText.value),
          child: Opacity(
            opacity: controller.opacetyColunm.value,
            child: Form(
              key: controller.formkey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(34, 50, 34, 0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.name,
                      style: Theme.of(context).textTheme.labelMedium,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter your name.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "What's your name?",
                        labelText: "Name",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
