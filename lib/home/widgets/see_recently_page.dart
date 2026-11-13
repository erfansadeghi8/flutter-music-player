import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/widgets/custom_list_songs.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/home/widgets/show_playing_music.dart';

class SeeRecentlyPage extends StatelessWidget {
  SeeRecentlyPage({super.key});

  final songController = Get.find<SongController>();

  @override
  Widget build(BuildContext context) {
    // Set the current playlist when page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (songController.songRecently.isNotEmpty) {
        songController.setCurrentPlaylist(songController.songRecently);
      }
    });

    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 20, 10),
        child: Column(
          children: [
            CustomListSongs(
              title: "Recently Played",
              folders: songController.songRecently,
              ontap: (song) async {
                if (songController.isChangingSong) return;
                songController.isChangingSong = true;
                try {
                  await songController.playeMusic(song.data);
                  if (songController.isplay.value) {
                    await songController.resetCurrentPostion();
                    songController.addRecentlySong(song.id);
                  }
                } finally {
                  songController.isChangingSong = false;
                }
              },
              height: 1.22,
            ),
            SizedBox(height: 20,) ,
            ShowPlayingMusic(),
          ],
        ),
      ),
    );
  }
}
