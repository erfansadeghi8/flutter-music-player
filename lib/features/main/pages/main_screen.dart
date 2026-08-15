import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/core/theme/app_theme_extension.dart';
import 'package:music_player/features/main/pages/homeController/main_screen_controller.dart';
import 'package:music_player/home/home_page.dart';
import 'package:music_player/home/widgets/app_bar_widget.dart';
import 'package:music_player/features/main/widgets/bottomnavbar.dart';
import 'package:music_player/home/widgets/list_all_songs.dart';
import 'package:music_player/home/widgets/list_recently_payed.dart';
import 'package:music_player/home/widgets/recently_payed.dart';
import 'package:music_player/home/widgets/show_playing_music.dart';
import 'package:music_player/home/widgets/title_all_songs.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final controller = Get.find<MainController>();
  final nameStorage = Storage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(
              context,
            ).extension<AppThemeExtension>()!.backgroundGradient,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Obx(() => controller.listnavbar[controller.selectedNavbar.value]),
              //Show playing music
              ShowPlayingMusic(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottomnavbar(),
    );
  }
}
