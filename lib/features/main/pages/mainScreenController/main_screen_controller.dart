import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_player/home/home_page.dart';
import 'package:music_player/library/Library_page.dart';
import 'package:music_player/playlist/PlayList_page.dart';
import 'package:music_player/search/Search_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MainController extends GetxController {
  RxInt selectedIndexListSong = 0.obs;
  RxBool isplay = false.obs;
  RxInt selectedNavbar = 0.obs;
  Rx<ThemeMode> selectedmodeTheme = ThemeMode.system.obs;
  final box = GetStorage();
  RxInt hour = 0.obs;
  RxInt minute = 0.obs;
  RxBool isActiveTimer = false.obs;

  List<Widget> listnavbar = [
    HomePage(),
    SearchPage(),
    LibraryPage(),
    PlaylistPage(),
  ];

  late final saveTheme = box.read("Theme");
  void funThemeMode() {
    if (saveTheme == "light") {
      selectedmodeTheme.value = ThemeMode.light;
    } else if (saveTheme == "Dark") {
      selectedmodeTheme.value = ThemeMode.dark;
    } else {
      selectedmodeTheme.value = ThemeMode.system;
    }
  }

  Future<void> linkdin(String urllinkdin) async {
    final Uri url = Uri.parse(urllinkdin);
    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        debugPrint("Could not launch : $url");
      }
    } catch (e) {
      debugPrint("Error : $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    funThemeMode();
    ever(selectedmodeTheme, (ThemeMode mode) {
      box.write("Theme", mode.name);
    });
  }
}
