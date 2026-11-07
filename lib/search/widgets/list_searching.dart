import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/search/searchController/search_controller.dart';

class ListSearching extends StatelessWidget {
  ListSearching({super.key});

  final SearchPageController searchPageController =
      Get.find<SearchPageController>();

  final SongController songController = Get.find<SongController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (searchPageController.listSearching.isEmpty) {
        return const SizedBox.shrink();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(230, 43, 43, 43),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: searchPageController.listSearching.length,
              itemBuilder: (context, index) {
                final song = searchPageController.listSearching[index];

                return InkWell(
                  onTap: () async {
                    if (songController.isChangingSong) return;

                    songController.isChangingSong = true;

                    try {
                      await songController.playeMusic(song.data);

                      if (songController.isplay.value) {
                        await songController.resetCurrentPostion();

                        songController.addRecentlySong(song.id);

                        await searchPageController.saveSearchingSongToStorage(
                          song.id,
                        );
                      }
                    } finally {
                      songController.isChangingSong = false;
                    }

                    FocusManager.instance.primaryFocus?.unfocus();

                    searchPageController.restListSearching();
                  },
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, size: 15),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    });
  }
}
