import 'package:get/get.dart';
import 'package:music_player/features/EqualizerPage/equalizerController/equalizer_page_controller.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/home/homeController/home_controller.dart';
import 'package:music_player/main/mainScreenController/main_screen_controller.dart';
import 'package:music_player/pageWelcom/pageWelcomController/pageWelcomController.dart';


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
    Get.put(MainController(), permanent: true);
    Get.put(SongController(), permanent: true);
  }
}

class SongControllerBilding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EqualizerController());
  }
}

class HomePageBilding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class EqualizerBilding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EqualizerController());
  }
}

