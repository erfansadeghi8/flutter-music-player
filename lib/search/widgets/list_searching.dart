import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:music_player/search/searchController/search_controller.dart';

class ListSearching extends StatelessWidget {
  ListSearching({super.key});
  final SearchPageController searchPageController = Get.put(
    SearchPageController(),
  );
  final songController = Get.find<SongController>();
  final mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 43, 43, 43),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                  } else {
                    await songController.audioPlayer.stop();
                  }
                } finally {
                  songController.isChangingSong = false;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                searchPageController.listRecentlySave.add(song);
                searchPageController.saveSearchingSongToStorage(song.id);
                searchPageController.restListSearching();
                
                
              },
              child: SizedBox(
                height: 50,
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
