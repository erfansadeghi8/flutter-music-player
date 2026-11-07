
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:music_player/core/services/storage.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';

class SearchPageController extends GetxController {
  final TextEditingController controllersearch =
      TextEditingController();

  final formkey = GlobalKey<FormState>();

  final listRecentlySave = <SongModel>[].obs;
  final listSearching = <SongModel>[].obs;

  final SongController songController =
      Get.find<SongController>();

  final MainController mainController =
      Get.find<MainController>();

  final storage = Storage();

  Timer? _debounce;
  Worker? _navbarWorker;

  // جستجوی آهنگ‌ها
  void onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        final query = value.trim().toLowerCase();

        if (query.isEmpty) {
          listSearching.clear();
          return;
        }

        listSearching.assignAll(
          songController.songs.where(
            (song) =>
                song.title.toLowerCase().contains(query),
          ),
        );
      },
    );
  }

  // ذخیره آهنگ در جستجوهای اخیر
  Future<void> saveSearchingSongToStorage(
    int songId,
  ) async {
    final existing = storage.readSaveSearchingSong();

    // حذف شناسه تکراری
    existing.removeWhere((id) => id == songId);

    // قرار دادن آهنگ در ابتدای لیست
    existing.insert(0, songId);

    await storage.saveSearchingSong(existing);

    final song = songController.songs.firstWhereOrNull(
      (item) => item.id == songId,
    );

    if (song != null) {
      listRecentlySave.removeWhere(
        (item) => item.id == songId,
      );

      listRecentlySave.insert(0, song);
    }
  }

  // دریافت جستجوهای اخیر از حافظه
  void readSaveSearchingSongToStorage() {
    final ids = storage.readSaveSearchingSong();

    final songs = ids
        .map(
          (id) => songController.songs.firstWhereOrNull(
            (song) => song.id == id,
          ),
        )
        .whereType<SongModel>()
        .toList();

    listRecentlySave.assignAll(songs);
  }

  // پاک کردن متن و نتایج جستجو
  void restListSearching() {
    controllersearch.clear();
    listSearching.clear();
  }

  // حذف یک آهنگ از جستجوهای اخیر
  Future<void> deleteRecentlySong(int songId) async {
    final existing = storage.readSaveSearchingSong();

    existing.removeWhere((id) => id == songId);

    await storage.saveSearchingSong(existing);

    listRecentlySave.removeWhere(
      (song) => song.id == songId,
    );
  }

  // حذف تمام جستجوهای اخیر
  Future<void> clearAllRecentlySongs() async {
    await storage.saveSearchingSong([]);

    listRecentlySave.clear();
  }

  @override
  void onInit() {
    super.onInit();

    readSaveSearchingSongToStorage();

    _navbarWorker = ever(
      mainController.selectedNavbar,
      (_) {
        restListSearching();
        readSaveSearchingSongToStorage();
      },
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    _navbarWorker?.dispose();
    controllersearch.dispose();

    super.onClose();
  }
}
