// ignore_for_file: file_names
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
    Future.delayed(Duration(seconds: 3), () {
      if (Storage().isFoundName()) {
        Get.offAndToNamed(AppRouter.mainscreen);
      } else {
        Get.offAndToNamed(AppRouter.welcomepage);
      }
    });
  }
}
