// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:music_player/search/searchController/search_controller.dart';

class ListRecentlySearch extends StatelessWidget {
  final SearchPageController searchPageController =
      Get.find<SearchPageController>();

  final songController = Get.find<SongController>();
  final mainController = Get.find<MainController>();

  ListRecentlySearch({super.key});

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

                try {
                  await songController.playeMusic(song.data);

                  if (songController.isplay.value) {
                    await songController.resetCurrentPostion();

                    await searchPageController.saveSearchingSongToStorage(
                      song.id,
                    );
                  }

                  mainController.selectedNavbar.value = 0;
                } finally {
                  songController.isChangingSong = false;
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: const Color.fromARGB(255, 95, 95, 95),
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded),
                    const SizedBox(width: 20),

                    Expanded(
                      child: Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 16,
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
                      onPressed: () async => await searchPageController
                          .deleteRecentlySong(song.id),
                      icon: const Icon(Icons.close),
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
