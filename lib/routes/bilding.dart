import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:music_player/core/widgets/splashScreen/splashScreenController/splashScreenController.dart';
import 'package:music_player/features/main/pages/homeController/main_screen_controller.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';
import 'package:music_player/home/homeController/home_controller.dart';

//Made bilding for splashScreenPageBilding
// ignore: camel_case_types
class splashScreenPageBilding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
  }
}

//Made bilding for WelcomePageBilding
class WelcomePageBilding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Pagewelcomcontroller());
  }
}

//Made bilding for HomePageBilding
class MainScreenBilding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}

class HomePageBilding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
