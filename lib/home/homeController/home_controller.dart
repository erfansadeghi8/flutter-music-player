import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  final songController = Get.find<SongController>();
  final _loadedSongId = Rxn<int>();
  RxInt selectedIndexListSong = 0.obs;
  RxInt selectedNavbar = 0.obs;
  RxBool isEqualizer = false.obs;
  RxInt selectedIndexEqualizer = 0.obs;
  Rx<Color> dmoninantColor = Color(0xFF202030).obs;
  Rx<Color> secondaryColor = Color(0xFF202030).obs;
  Rx<Uint8List> a = Uint8List(0).obs;

  Future<void> selectedColorImage(int id) async {
    if (_loadedSongId.value == id) return;
    _loadedSongId.value = id;
    Uint8List? artwork = await songController.audioQuery.queryArtwork(
      id, // همان _id که در خروجی دیدید (6947)
      ArtworkType.AUDIO,
    );
    if (artwork != null) {
      a.value = artwork;
      //   final palate = await PaletteGenerator.fromImageProvider(
      //     MemoryImage(a.value),
      //     maximumColorCount: 16,
      //   );

      //   dmoninantColor.value =
      //       palate.dominantColor?.color ?? const Color(0xFF202030);

      //   secondaryColor.value =
      //       palate.darkMutedColor?.color ?? const Color(0xFF101018);
      // } else {
      //   dmoninantColor.value = const Color(0xFF202030);
      //   secondaryColor.value = const Color(0xFF101018);
    }
  }
}
