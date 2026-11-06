// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:music_player/routes/router.dart';

class RecentlyPayed extends StatelessWidget {
  const RecentlyPayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Recently Played", style: Theme.of(context).textTheme.labelMedium),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRouter.seeRecentlyPage);
          },
          child: Text("See All", style: Theme.of(context).textTheme.titleSmall),
        ),
      ],
    );
  }
}
