import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/theme/app_theme_extension_timer.dart';
import 'package:music_player/core/widgets/music_animation_widget/music_animation_widget.dart';
import 'package:music_player/features/EqualizerPage/equalizer_page.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/home/widgets/modal_control_voice_song.dart';
import 'package:music_player/routes/router.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:marquee/marquee.dart';

class ShowModalPagePlayMusic extends StatelessWidget {
  ShowModalPagePlayMusic({super.key});
  final songController = Get.find<SongController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final latestSong = songController.songRecentlyStorage.reduce(
        (a, b) => a.lastPlayedAt.isAfter(b.lastPlayedAt) ? a : b,
      );
      final song = songController.songs.firstWhere(
        (song) => song.id == latestSong.songId,
      );
      return Material(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(
                context,
              ).extension<AppThemeExtensionTimer>()!.backgroundGradient,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Column(
              children: [
                //navbar page
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
                    Obx(
                      () => songController.isplay.value
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
                                  "Lyra",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
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
                        Get.toNamed(AppRouter.equalizerPage);
                        // showGeneralDialog(
                        //   context: context,
                        //   barrierDismissible: true,
                        //   barrierLabel: "equalizer",
                        //   transitionDuration: const Duration(milliseconds: 300),
                        //   pageBuilder:
                        //       (context, animation, secondaryAnimation) {
                        //         return EqualizerPage();
                        //       },
                        // );
                      },
                      icon: Icon(Icons.more_vert, size: 40),
                    ),
                  ],
                ),
                // picture for song
                Expanded(
                  flex: 3,
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Container(
                            width: songController.isplay.value
                                ? AppSize.wdith(context) / 1.2
                                : AppSize.wdith(context) / 2.2,
                            height: songController.isplay.value
                                ? AppSize.height(context) / 2.8
                                : AppSize.height(context) / 4.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: QueryArtworkWidget(
                              id: song.id!,
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
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        //title music and save to favorite
                        child: Center(
                          child: Column(
                            children: [
                              Obx(() {
                                final current =
                                    songController.currentSong.value;

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
                                      ? Icon(Icons.favorite, color: Colors.red)
                                      : Icon(Icons.favorite_outline),
                                );
                              }),
                              Text(
                                textAlign: TextAlign.center,
                                song.title!,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium!.copyWith(fontSize: 20),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 30,
                                width: AppSize.wdith(context) / 4,
                                child: Marquee(
                                  text:
                                      songController.currentSong.value?.artist
                                          .toString() ??
                                      "Unknown Artist",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 80.0,
                                  velocity: 40.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration: Duration(
                                    milliseconds: 500,
                                  ),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color.fromARGB(
                            255,
                            0,
                            158,
                            197,
                          ),
                          inactiveTrackColor: const Color.fromARGB(
                            192,
                            255,
                            255,
                            255,
                          ),
                          thumbColor: const Color.fromARGB(255, 0, 106, 114),
                          trackHeight: 4,
                          overlayColor: const Color.fromARGB(
                            122,
                            141,
                            141,
                            141,
                          ),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                        ),
                        child: Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Slider(
                                  min: 0,
                                  max: songController.tottalTime.value.inSeconds
                                      .toDouble(),
                                  value: songController
                                      .friesTime
                                      .value
                                      .inSeconds
                                      .toDouble()
                                      .clamp(
                                        0,
                                        songController
                                            .tottalTime
                                            .value
                                            .inSeconds
                                            .toDouble(),
                                      ),
                                  onChanged: (value) {
                                    songController.audioPlayer.seek(
                                      Duration(seconds: value.toInt()),
                                    );
                                    songController.saveCurrentPostion();
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
                          );
                        }),
                      ),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //button choose  random song
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.transparent,
                                  ),
                                ),
                                onPressed: () {
                                  songController.isrendom.value =
                                      !songController.isrendom.value;
                                },
                                icon: songController.isrendom.value
                                    ? Icon(
                                        CupertinoIcons.shuffle,
                                        color: const Color.fromARGB(
                                          255,
                                          103,
                                          230,
                                          0,
                                        ),
                                        size: 30,
                                      )
                                    : Icon(CupertinoIcons.shuffle, size: 30),
                              ),
                              // button back song
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
                              //button play or pusse
                              IconButton(
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(50),
                                    ),
                                  ),
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      color: ColorBtn
                                          .backgroundColorBtnWelcommDarkmode,
                                      width: 2,
                                    ),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.transparent,
                                  ),
                                ),
                                onPressed: () async {
                                  if (songController.isplay.value) {
                                    songController.pussMusic();
                                  } else {
                                    await songController.playeMusic(song.data!);
                                    songController.isplay.value = true;
                                  }
                                },
                                icon: songController.isplay.value
                                    ? Icon(Icons.pause, size: 50)
                                    : Icon(Icons.play_arrow, size: 50),
                              ),
                              // button next song
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
                              //button repet song
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
                                    ? Icon(
                                        Icons.repeat_one_sharp,
                                        color: const Color.fromARGB(
                                          255,
                                          218,
                                          255,
                                          8,
                                        ),
                                        size: 30,
                                      )
                                    : Icon(Icons.repeat, size: 30),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
