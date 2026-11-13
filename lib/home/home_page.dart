// ignore_for_file: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:music_player/home/widgets/list_all_songs.dart';
import 'package:music_player/home/widgets/list_recently_payed.dart';
import 'package:music_player/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recently Played",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRouter.seeRecentlyPage);
              },
              child: Text(
                "See All",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
        ListRecentlyPayed(),
        Text(
          "All Songs",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        ListAllSongs(),
      ],
    );
  }
}
