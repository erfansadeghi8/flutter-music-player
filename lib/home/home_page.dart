import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/home/widgets/list_all_songs.dart';
import 'package:music_player/home/widgets/list_recently_payed.dart';
import 'package:music_player/home/widgets/recently_payed.dart';
import 'package:music_player/home/widgets/title_all_songs.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RecentlyPayed(),
        ListRecentlyPayed(),
        TitleAllSongs(),
        ListAllSongs(),
      ],
    );
  }
}
