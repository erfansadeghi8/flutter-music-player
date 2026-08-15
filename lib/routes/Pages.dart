// ignore: file_names
import 'package:get/get.dart';
import 'package:music_player/core/widgets/splashScreen/splashScreen.dart';
import 'package:music_player/features/main/pages/main_screen.dart';
import 'package:music_player/features/pageWelcom/pageWelcom.dart';
import 'package:music_player/home/home_page.dart';
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
      name: AppRouter.mainscreen,
      page: () => MainScreen(),
      binding: MainScreenBilding(),
    ),
    GetPage(
      name: AppRouter.homescreen,
      page: () => HomePage(),
      binding: HomePageBilding(),
    ),
  ];
}
