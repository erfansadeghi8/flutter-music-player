// ignore: file_names
import 'package:get/get.dart';
import 'package:music_player/core/widgets/splashScreen/splashScreen.dart';
import 'package:music_player/features/home/pages/homePage.dart';
import 'package:music_player/features/pageWelcom/pageWelcom.dart';
import 'package:music_player/routes/bilding.dart';
import 'package:music_player/routes/router.dart';

class AppPages {
  static final pages = <GetPage>[
    //Create a page for Splashscreen
    GetPage(
      name: AppRouter.splash,
      page: () => Splashscreen(),
      binding: splashScreenPageBilding(),
    ),
    //Create a page for PageWelcom
    GetPage(
      name: AppRouter.welcomepage,
      page: () => PageWelcom(),
      binding: WelcomePageBilding(),
    ),
    //Create a page for HomePage
    GetPage(
      name: AppRouter.homescreen,
      page: () => HomePage(),
      binding: WelcomePageBilding(),
    ),
  ];
}
