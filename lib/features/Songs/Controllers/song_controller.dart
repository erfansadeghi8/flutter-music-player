import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/data/models/model_recently_song.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final songs = <SongModel>[].obs;
  final songRecently = <SongModel>[].obs;
  final songRecentlyStorage = <ModelRecentlySong>[].obs;
  final storage = Storage();
  final AudioPlayer audioPlayer = AudioPlayer();
  final Rxn<SongModel> currentSong = Rxn<SongModel>();
  RxBool isplay = false.obs;
  RxBool isfavoritSong = false.obs;
  RxInt nextIndex = 0.obs;
  RxInt backIndex = 0.obs;
  final Rxn<SongModel> nextAndBackSongMusic = Rxn<SongModel>();

  Future<void> loadSongs() async {
    final permission = await audioQuery.permissionsRequest();

    if (!permission) {
      // ignore: avoid_print
      print("Permission denied");
      return;
    }
    final result = await audioQuery.querySongs();
    songs.assignAll(result);
  }

  void saveRecentlyGetstorage() {
    final date = songRecentlyStorage.map((song) {
      return song.toJson();
    }).toList();
    storage.saveReently(date);
  }

  void loadRecentlySong() {
    final readData = storage.readSaveRecentlySong();

    final recentlyList = readData.map((song) {
      return ModelRecentlySong.fromJson(song);
    }).toList();
    final oldLength = recentlyList.length;
    recentlyList.removeWhere((song) {
      return DateTime.now().difference(song.lastPlayedAt) >=
          const Duration(days: 30);
    });
    songRecentlyStorage.assignAll(recentlyList);

    if (oldLength != recentlyList.length) {
      saveRecentlyGetstorage();
    }
  }

  void addRecentlySong(int id) {
    final isExist = songRecentlyStorage.any((song) => song.songId == id);

    if (isExist) {
      final date = songRecentlyStorage.firstWhere(
        (element) => element.songId == id,
      );

      date.lastPlayedAt = DateTime.now();
    } else {
      songRecentlyStorage.add(
        ModelRecentlySong(songId: id, lastPlayedAt: DateTime.now()),
      );
    }
    saveRecentlyGetstorage();
    updateRecentlySong();
  }

  void updateRecentlySong() {
    final date = songs.where((song) {
      return songRecentlyStorage.any((result) => result.songId == song.id);
    }).toList();

    songRecently.assignAll(date);
  }

  Future<void> loadRecentlyData() async {
    await loadSongs();
    loadRecentlySong();
    updateRecentlySong();
    final latestSong = songRecentlyStorage.reduce(
      (a, b) => a.lastPlayedAt.isAfter(b.lastPlayedAt) ? a : b,
    );
    final currentIndex = songs.indexWhere(
      (song) => song.id == latestSong.songId,
    );
    currentSong.value = songs[currentIndex];
  }

  // ignore: strict_top_level_inference
  Future<void> playeMusic(urlmusic) async {
    await audioPlayer.play(DeviceFileSource(urlmusic));
    isplay.value = true;
  }

  Future<void> nextSong() async {
    final latestSong = songRecentlyStorage.reduce(
      (a, b) => a.lastPlayedAt.isAfter(b.lastPlayedAt) ? a : b,
    );
    final currentIndex = songs.indexWhere(
      (song) => song.id == latestSong.songId,
    );
    nextIndex.value = currentIndex + 1;

    if (nextIndex.value >= songs.length) {
      nextIndex.value = 0;
    }

    nextAndBackSongMusic.value = songs[nextIndex.value];
    currentSong.value = nextAndBackSongMusic.value;

    addRecentlySong(nextAndBackSongMusic.value!.id);

    await audioPlayer.stop();

    await playeMusic(nextAndBackSongMusic.value!.data);
  }

  Future<void> backSong() async {
    final latestSong = songRecentlyStorage.reduce(
      (a, b) => a.lastPlayedAt.isAfter(b.lastPlayedAt) ? a : b,
    );
    final currentIndex = songs.indexWhere(
      (song) => song.id == latestSong.songId,
    );
    backIndex.value = currentIndex - 1;
    if (backIndex.value >= 0) {
      nextAndBackSongMusic.value = songs[backIndex.value];
      currentSong.value = nextAndBackSongMusic.value;
      addRecentlySong(nextAndBackSongMusic.value!.id);
      await audioPlayer.stop();
      await playeMusic(nextAndBackSongMusic.value!.data);
    } else {
      backIndex.value = songs.length - 1;
      nextAndBackSongMusic.value = songs[backIndex.value];
      currentSong.value = nextAndBackSongMusic.value;
      addRecentlySong(nextAndBackSongMusic.value!.id);
      await audioPlayer.stop();
      await playeMusic(nextAndBackSongMusic.value!.data);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadRecentlyData();
  }

  @override
  void onClose() {
    super.onClose();
    audioPlayer.dispose();
  }
}
