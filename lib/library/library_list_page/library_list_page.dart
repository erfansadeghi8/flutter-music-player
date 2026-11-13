// ignore_for_file: unnecessary_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:music_player/core/widgets/custom_list_songs.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/home/widgets/show_playing_music.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LibraryListPage extends StatelessWidget {
  LibraryListPage({super.key});

  final SongController songController = Get.find<SongController>();
  final folder = Get.arguments["songs"];

  @override
  Widget build(BuildContext context) {
    // Set the current playlist when page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final songsList = Get.arguments["songs"] as List<SongModel>?;
      if (songsList != null && songsList.isNotEmpty) {
        songController.setCurrentPlaylist(songsList);
      }
    });

    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
        child: Column(
          children: [
            Expanded(
              child: CustomListSongs(
                height: 1.22,
                title: Get.arguments["name"],
                folders: folder,

                ontap: (song) async {
                  if (songController.isChangingSong) return;

                  songController.isChangingSong = true;

                  try {
                    await songController.playeMusic(song.data);

                    if (songController.isplay.value) {
                      await songController.resetCurrentPostion();
                      songController.addRecentlySong(song.id);
                    }
                  } catch (e) {
                    debugPrint('Play music error: $e');
                  } finally {
                    songController.isChangingSong = false;
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            Obx(() {
              final currentSong = songController.currentSong.value;

              if (currentSong == null) {
                return const SizedBox.shrink();
              }

              return ShowPlayingMusic();
            }),
          ],
        ),
      ),
    );
  }
}
