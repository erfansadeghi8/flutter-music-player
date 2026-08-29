// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/core/theme/app_theme_extension.dart';
import 'package:music_player/data/models/date_time_day.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final nameStorage = Storage();

  AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 90,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(
              context,
            ).extension<AppThemeExtension>()!.backgroundGradient,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.menu),
        style: IconButton.styleFrom(backgroundColor: Colors.transparent),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateTimeDay().dateTimeOfDayFun(),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          SizedBox(height: 4),
          Text(
            "${nameStorage.readName()} 😉",
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 18),
          ),
        ],
      ),
      actions: [
        Image.asset(
          "assets/icon/iconAppbar.png",
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
