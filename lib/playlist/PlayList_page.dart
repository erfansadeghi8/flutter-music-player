// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/data/models/date_time_day.dart';
import 'package:music_player/home/widgets/show_playing_music.dart';

class PlaylistPage extends StatelessWidget {
  PlaylistPage({super.key});
  final nameStorage = Storage();

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: Text(
            "Profile",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 20),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/profile/avatar.jpg",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${nameStorage.readName()} 😉",
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(fontSize: 18),
              ),
              Text(
                DateTimeDay().dateTimeOfDayFun(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: 4),
            ],
          ),
        ),

        ShowPlayingMusic(),
      ],
    );
  }
}
