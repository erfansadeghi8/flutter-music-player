import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/home/homeController/home_controller.dart';
import 'package:music_player/home/widgets/show_modal_page_play_music.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ShowPlayingMusic extends StatelessWidget {
  ShowPlayingMusic({super.key});
  final controller = Get.put(HomeController());
  final songController = Get.find<SongController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final song = songController.currentSong.value;

      if (song == null) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
        child: InkWell(
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: "PlayMusic",
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return ShowModalPagePlayMusic();
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(40, 163, 163, 163),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: QueryArtworkWidget(
                            key: ValueKey(song.id),
                            id: song.id,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.cover,
                            artworkBorder: BorderRadius.circular(10),
                            nullArtworkWidget: Image.asset(
                              "assets/RecentlyMusic/null_is_poster2.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                song.artist ?? "Unknown Artist",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Obx(() {
                      return IconButton(
                        style:  IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent
                        ),
                        onPressed: () async {
                          if (songController.isplay.value) {
                            songController.pussMusic();
                          } else {
                            await songController.playeMusic(song.data);
                          }
                        },
                        icon: Icon(
                          songController.isplay.value
                              ? Icons.pause_outlined
                              : Icons.play_arrow_outlined,
                          size: 40,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
