import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/theme/app_theme_extension.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';

class Bottomnavbar extends StatelessWidget {
  Bottomnavbar({super.key});
  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.size(context).height / 11,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(
            context,
          ).extension<AppThemeExtension>()!.backgroundGradient,
        ),
      ),
      child: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          currentIndex: controller.selectedNavbar.value,

          onTap: (index) {
            controller.selectedNavbar.value = index;
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              label: "Library",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
