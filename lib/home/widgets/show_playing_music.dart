import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/home/homeController/home_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ShowPlayingMusic extends StatelessWidget {
  ShowPlayingMusic({super.key});
  final controller = Get.put(HomeController());
  final songController = Get.put(SongController());

  @override
  Widget build(BuildContext context) {
    final objectMusicPlay = songController.songRecently.last;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(40, 163, 163, 163),
        ),
        child: Padding(
          padding: EdgeInsets.all(4),
          //row lider
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // row iamge and text
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: QueryArtworkWidget(
                        id: objectMusicPlay.id,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        artworkBorder: BorderRadius.circular(10),
                        nullArtworkWidget: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/RecentlyMusic/null_is_poster2.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            objectMusicPlay.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            objectMusicPlay.artist ?? "Unknown Artist",
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                    ),
                    onPressed: () {
                      controller.isplay.value = !controller.isplay.value;
                    },
                    icon: controller.isplay.value
                        ? Icon(Icons.pause_outlined, size: 40)
                        : Icon(Icons.play_arrow_outlined, size: 40),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
