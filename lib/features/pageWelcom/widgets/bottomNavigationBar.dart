// ignore: file_names
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';
import 'package:music_player/routes/router.dart';

class BottomNavigationBarwidget extends StatelessWidget {
  BottomNavigationBarwidget({super.key});

  final Pagewelcomcontroller controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      //Key to go to the next page
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color.fromARGB(255, 149, 32, 196),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        ),
        onPressed: () {
          //
          if (controller.pageIndex.value == 3) {
            //Variable to understand
            final isValid =
                controller.formkey.currentState?.validate() ?? false;

            if (isValid) {
              Get.offAndToNamed(AppRouter.homescreen);
            } else {
              Get.snackbar(
                "Error",
                "You must enter your name.",
                backgroundColor: Colors.yellow,
                colorText: Colors.black,
              );
            }
            return;
          }
          //If the index was from 1 to 2, add this.
          if (controller.pageIndex.value < 3) {
            controller.pageIndex.value++;
          }
        },
        child: Obx(() {
          return Text(
            controller.pageIndex.value == 3 ? "Get Started" : "Next",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ),
    );
  }
}
