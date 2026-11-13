// ignore_for_file: unnecessary_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CustomListSongs extends StatelessWidget {
  final String title;
  final List<SongModel> folders;
  final Future<void> Function(SongModel song)? ontap;
  final double? height;

  const CustomListSongs({
    super.key,
    required this.title,
    required this.folders,
    required this.ontap,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.height(context) / height! ,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back, size: 35),
              ),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(fontSize: 20),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: folders.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // ignore: unused_local_variable
                final listAllSongs = folders[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap:() async {
                      await ontap?.call(listAllSongs);
                    },

                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(0, 105, 105, 105),
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
        ],
      ),
    );
  }
}
