import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SeeRecentlyPage extends StatelessWidget {
  SeeRecentlyPage({super.key});

  final songController = Get.find<SongController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back, size: 35),
              ),
            ],
          ),
          Obx(() {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: songController.songRecently.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    // ignore: unused_local_variable
                    final listAllSongs = songController.songRecently[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          // songController.sortRecentlySongs();

                          if (songController.isChangingSong) return;
                          songController.isChangingSong = true;
                          await songController.playeMusic(listAllSongs.data);

                          try {
                            if (songController.isplay.value) {
                              await songController.playeMusic(
                                listAllSongs.data,
                              );
                              await songController.resetCurrentPostion();
                              songController.addRecentlySong(listAllSongs.id);
                            } else {
                              await songController.audioPlayer.stop();
                            }
                          } finally {
                            songController.isChangingSong = false;
                          }
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: QueryArtworkWidget(
                                            id: listAllSongs.id,
                                            type: ArtworkType.AUDIO,
                                            artworkFit: BoxFit.cover,
                                            artworkBorder:
                                                BorderRadius.circular(8),
                                            nullArtworkWidget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
