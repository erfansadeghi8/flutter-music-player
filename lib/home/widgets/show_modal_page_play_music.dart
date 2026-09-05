import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/theme/app_theme_extension_timer.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ShowModalPagePlayMusic extends StatelessWidget {
  ShowModalPagePlayMusic({super.key, required this.song});
  final SongModel song;
  final songController = Get.find<SongController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(
              context,
            ).extension<AppThemeExtensionTimer>()!.backgroundGradient,
          ),
        ),
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_drop_down_outlined, size: 40),
                    ),
                    Text(
                      "Playing music",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.more_vert, size: 40),
                    ),
                  ],
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: AppSize.wdith(context) / 1.2,
                        height: AppSize.height(context) / 2.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: QueryArtworkWidget(
                          id: songController.currentSong.value!.id,
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
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  songController.currentSong.value!.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  songController.currentSong.value!.artist ??
                                      "Unknown Artist",
                                  style: Theme.of(context).textTheme.labelSmall!
                                      .copyWith(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            IconButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Colors.transparent,
                                ),
                              ),
                              onPressed: () {
                                songController.isfavoritSong.value =
                                    !songController.isfavoritSong.value;
                              },

                              icon: songController.isfavoritSong.value
                                  ? Icon(
                                      Icons.favorite,
                                      size: 25,
                                      color: Colors.redAccent,
                                    )
                                  : Icon(Icons.favorite_border, size: 25),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color.fromARGB(
                            255,
                            216,
                            11,
                            235,
                          ),
                          inactiveTrackColor: Colors.white24,
                          thumbColor: const Color.fromARGB(255, 104, 2, 124),
                          trackHeight: 4,
                          overlayColor: Colors.transparent,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Slider(
                                min: 0,
                                max: 100,
                                value: 20,
                                onChanged: (value) {},
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text("00:00"), Text("3:20")],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.shuffle, size: 30),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                          onPressed: () async {
                            songController.backSong();
                          },
                          icon: Icon(Icons.skip_previous, size: 35),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              ColorBtn.backgroundColorBtnWelcommDarkmode,
                            ),
                          ),
                          onPressed: () {
                            if (songController.isplay.value) {
                              songController.audioPlayer.pause();
                              songController.isplay.value = false;
                            } else {
                              songController.playeMusic(song.data);
                              songController.isplay.value = false;
                            }
                          },
                          icon: songController.isplay.value
                              ? Icon(Icons.pause, size: 50)
                              : Icon(Icons.play_arrow, size: 50),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                          onPressed: () async {
                            songController.nextSong();
                          },
                          icon: Icon(Icons.skip_next, size: 35),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.repeat, size: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
