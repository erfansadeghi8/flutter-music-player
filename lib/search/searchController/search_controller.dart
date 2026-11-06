import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchPageController extends GetxController {
  final TextEditingController controllersearch = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final listRecentlySave = <SongModel>[].obs;
  final listSearching = <SongModel>[].obs;
  final SongController songController = Get.put(SongController());
  final mainController = Get.find<MainController>();
  final storage = Storage();

  Timer? _debounce;

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = value.trim().toLowerCase();

      if (query.isEmpty) {
        listSearching.clear();
        return;
      }

      listSearching.assignAll(
        songController.songs.where(
          (song) => song.title.toLowerCase().contains(query),
        ),
      );
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    controllersearch.dispose();
    super.onClose();
  }

  // ignore: strict_top_level_inference
  Future<void> saveSearchingSongToStorage(int songId) async {
    final existing = storage.readSaveSearchingSong();

    if (!existing.contains(songId)) {
      existing.insert(0, songId);
      await storage.saveSearchingSong(existing);
    }

    final song = songController.songs.firstWhereOrNull(
      (item) => item.id == songId,
    );

    if (song != null && !listRecentlySave.any((item) => item.id == songId)) {
      listRecentlySave.insert(0, song);
    }
  }

  void readSaveSearchingSongToStorage() {
    final ids = storage.readSaveSearchingSong();

    final songs = ids
        .map(
          (id) =>
              songController.songs.firstWhereOrNull((song) => song.id == id),
        )
        .whereType<SongModel>()
        .toList();

    listRecentlySave.assignAll(songs);
  }

  void restListSearching() {
    controllersearch.clear();
    listSearching.clear();
  }

  Future<void> deleteRecentlySong(int songId) async {
    final stor = storage.readSaveSearchingSong();

    stor.removeWhere((id) => id == songId);

    await storage.saveSearchingSong(stor);

    listRecentlySave.removeWhere((song) => song.id == songId);
  }

  Future<void> clearAllRecentlySongs() async {
    await storage.saveSearchingSong([]);
    listRecentlySave.clear();
  }

  @override
  void onInit() {
    super.onInit();

    ever(mainController.selectedNavbar, (callback) {
      restListSearching();
      readSaveSearchingSongToStorage();
    });

    readSaveSearchingSongToStorage();
  }
}
