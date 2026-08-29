import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/theme/app_theme_extension_timer.dart';
import 'package:music_player/core/widgets/music_animation_widget/music_animation_widget.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(
            context,
          ).extension<AppThemeExtensionTimer>()!.backgroundGradient,
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 175, 175, 175),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? shadow.shadowAboutAppDarkMode.withOpacity(.5)
                      : const Color.fromARGB(255, 112, 112, 112),
                  spreadRadius: 2, // How much the shadow expands
                  blurRadius: 5, // How soft the shadow looks
                  offset: const Offset(0, 3), // Shadow position (x, y)
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 30, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, size: 35),
                  ),
                  Text(
                    "About App",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(fontSize: 25),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Image.asset(
            "assets/icon/icon_app.png",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Text(
            textAlign: TextAlign.center,
            "Lyra",
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontSize: 35),
          ),
          //version
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.8))],
                color: Theme.of(context).brightness == Brightness.dark
                    ? shadow.shadowAboutAppDarkMode
                    : const Color.fromARGB(255, 145, 145, 145),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'About',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Lyra is a simple, modern, and elegant music player designed to make listening'
                        'to your favorite music easy and enjoyable.'
                        'With Lyra, you can browse and play your songs,'
                        'manage your favorite tracks, and enjoy a clean '
                        'and smooth music experience without unnecessary complexity',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.8))],
                color: Theme.of(context).brightness == Brightness.dark
                    ? shadow.shadowAboutAppDarkMode
                    : const Color.fromARGB(255, 110, 110, 110),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Developer: ",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      textAlign: TextAlign.center,
                      "Erfan sadeghi",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.8))],
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(199, 122, 122, 122),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Version : ",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "(1.0.0)",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: AppSize.height(context) / 4,
            child: MusicAnimationWidget(),
          ),
        ],
      ),
    );
  }
}
