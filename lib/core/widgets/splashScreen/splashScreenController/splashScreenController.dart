// ignore_for_file: file_names
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/routes/router.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // A function to go to the page Welcomm
    splahScreen();
  }

  void splahScreen() {
    if (Storage().isFoundName()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(AppRouter.mainscreen);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(AppRouter.welcomepage);
      });
    }
    // Future.delayed(Duration(seconds: 3), () {
    // });
  }
}
