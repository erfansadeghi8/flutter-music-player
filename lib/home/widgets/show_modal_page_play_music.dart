import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/theme/app_theme_extension_timer.dart';
import 'package:music_player/core/widgets/music_animation_widget/music_animation_widget.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/home/widgets/modal_control_voice_song.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ShowModalPagePlayMusic extends StatelessWidget {
  ShowModalPagePlayMusic({super.key});
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
                    songController.isplay.value
                        ? SizedBox(
                            width: 100,
                            height: 100,
                            child: MusicAnimationWidget(),
                          )
                        : SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,

                                "Playing music",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: "equalizer",
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                                return ModalControlVoiceSong();
                              },
                        );
                      },
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
                            Expanded(
                              child: Column(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(fontSize: 20),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              final current = songController.currentSong.value;

                              if (current == null) {
                                return const SizedBox();
                              }

                              final isFavorite = songController.favoriteSongs
                                  .any((item) => item.songId == current.id);

                              return IconButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.transparent,
                                  ),
                                ),
                                onPressed: () async {
                                  await songController.toggleFavorite(
                                    current.id,
                                  );
                                },
                                icon: isFavorite
                                    ? Icon(
                                        Icons.favorite_border,
                                        color: Colors.red,
                                      )
                                    : Icon(Icons.favorite_outline),
                              );
                            }),
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
                                max: songController.tottalTime.value.inSeconds
                                    .toDouble(),
                                value: songController.friesTime.value.inSeconds
                                    .toDouble()
                                    .clamp(
                                      0,
                                      songController.tottalTime.value.inSeconds
                                          .toDouble(),
                                    ),
                                onChanged: (value) {
                                  songController.audioPlayer.seek(
                                    Duration(seconds: value.toInt()),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${songController.friesTime.value.inMinutes.toString().padLeft(2, '0')}:${(songController.friesTime.value.inSeconds % 60).toString().padLeft(2, '0')}",
                                    ),
                                    Text(
                                      "${songController.tottalTime.value.inMinutes.toString().padLeft(2, '0')}:${(songController.tottalTime.value.inSeconds % 60).toString().padLeft(2, '0')}",
                                    ),
                                  ],
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
                              songController.isrendom.value
                                  ? const Color.fromARGB(144, 31, 105, 128)
                                  : Colors.transparent,
                            ),
                          ),
                          onPressed: () {
                            songController.isrendom.value =
                                !songController.isrendom.value;
                          },
                          icon: songController.isrendom.value
                              ? Icon(Icons.shuffle_on_outlined, size: 30)
                              : Icon(Icons.shuffle, size: 30),
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
                          onPressed: () async {
                            if (songController.isplay.value) {
                              await songController.audioPlayer.pause();
                              songController.isplay.value = false;
                            } else {
                              await songController.playeMusic(
                                songController.currentSong.value!.data,
                              );
                              songController.isplay.value = true;
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
                          onPressed: () {
                            songController.isRepet.value =
                                !songController.isRepet.value;
                          },
                          icon: songController.isRepet.value
                              ? Icon(Icons.repeat_on, size: 30)
                              : Icon(Icons.repeat, size: 30),
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
