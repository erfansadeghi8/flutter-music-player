// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListAllSongs extends StatelessWidget {
  ListAllSongs({super.key});
  final songController = Get.put(SongController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (songController.songs.isNotEmpty) {
        return SizedBox(
          height: songController.songRecently.isNotEmpty
              ? AppSize.size(context).height / 2.75
              : AppSize.size(context).height / 1.55,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: songController.songs.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // ignore: unused_local_variable
                final listAllSongs = songController.songs[index];
                return InkWell(
                  onTap: () {
                    songController.addRecentlySong(listAllSongs.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(40, 105, 105, 105),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        //row lider
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // row iamge and text
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: QueryArtworkWidget(
                                      id: listAllSongs.id,
                                      type: ArtworkType.AUDIO,
                                      artworkFit: BoxFit.cover,
                                      artworkBorder: BorderRadius.circular(8),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listAllSongs.title,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          listAllSongs.artist ??
                                              "Unknown Artist",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/icon/voice.png",
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
      return Text(
        textAlign: TextAlign.center,
        "Not Found Songs",
        style: Theme.of(context).textTheme.labelSmall,
      );
    });
  }
}
