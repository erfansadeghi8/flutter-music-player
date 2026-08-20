import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/core/theme/app_theme_extension.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:music_player/features/main/widgets/bottomnavbar.dart';
import 'package:music_player/home/widgets/app_bar_widget.dart';
import 'package:music_player/home/widgets/show_playing_music.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final controller = Get.find<MainController>();
  final songController = Get.put(SongController());
  final nameStorage = Storage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Obx(
          () => controller.selectedNavbar.value == 0
              ? AppBarWidget()
              : const SizedBox.shrink(),
        ),
      ),
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
              Expanded(
                child: Obx(
                  () => controller.listnavbar[controller.selectedNavbar.value],
                ),
              ),

              //Show playing music
              // ignore: unrelated_type_equality_checks
              Obx(() {
                if (controller.selectedNavbar == 0 &&
                    songController.songRecently.isNotEmpty) {
                  return ShowPlayingMusic();
                }
                return SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottomnavbar(),
    );
  }
}
