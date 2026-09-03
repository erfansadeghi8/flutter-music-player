import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListRecentlyPayed extends StatelessWidget {
  ListRecentlyPayed({super.key});
  final songController = Get.put(SongController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (songController.songRecently.isNotEmpty) {
        return SizedBox(
          height: AppSize.height(context) / 5,
          child: InkWell(
            child: ListView.builder(
              itemCount: songController.songRecently.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final listmusicrecently = songController.songRecently[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: QueryArtworkWidget(
                          id: listmusicrecently.id,
                          type: ArtworkType.AUDIO,
                          artworkFit: BoxFit.cover,
                          artworkBorder: BorderRadius.circular(8),
                          nullArtworkWidget: Image.asset(
                            "assets/RecentlyMusic/null_is_poster2.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: 110,
                        child: Text(
                          listmusicrecently.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        listmusicrecently.artist ?? "Unknown Artist",
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
      return Text(
        "not recently songs",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall,
      );
    });
  }
}
