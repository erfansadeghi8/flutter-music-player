import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:music_player/search/searchController/search_controller.dart';

class ListRecentlySearch extends StatelessWidget {
  ListRecentlySearch({super.key});

  final SearchPageController searchPageController =
      Get.find<SearchPageController>();

  final SongController songController = Get.find<SongController>();

  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: searchPageController.listRecentlySave.length,
          itemBuilder: (context, index) {
            final song = searchPageController.listRecentlySave[index];

            return InkWell(
              onTap: () async {
                if (songController.isChangingSong) return;

                songController.isChangingSong = true;
                // Clear playlist to use global songs list
                songController.clearCurrentPlaylist();

                bool success = false;

                try {
                  await songController.playeMusic(song.data);

                  if (songController.isplay.value) {
                    await songController.resetCurrentPostion();

                    await searchPageController.saveSearchingSongToStorage(
                      song.id,
                    );

                    success = true;
                  }
                } finally {
                  songController.isChangingSong = false;
                }

                if (success) {
                  mainController.selectedNavbar.value = 0;
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 95, 95, 95),
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded ,size: 15,),
                    const SizedBox(width: 20),

                    Expanded(
                      child: Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),

                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () async {
                        await searchPageController.deleteRecentlySong(song.id);
                      },
                      icon: const Icon(Icons.close ,size: 16,),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
