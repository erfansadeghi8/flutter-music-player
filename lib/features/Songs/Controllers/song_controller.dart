import 'dart:math';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/data/models/model_favorite_songs.dart';
import 'package:music_player/data/models/model_recently_song.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();

  final songs = <SongModel>[].obs;
  final songRecently = <SongModel>[].obs;
  final songRecentlyStorage = <ModelRecentlySong>[].obs;
  final favoriteSongs = <ModelFavoriteSongs>[].obs;

  final storage = Storage();

  // مهم:
  // از این به بعد AudioPlayer از just_audio است
  final AudioPlayer audioPlayer = AudioPlayer();

  final Rxn<SongModel> currentSong = Rxn<SongModel>();
  final Rxn<SongModel> nextAndBackSongMusic = Rxn<SongModel>();

  final friesTime = Duration().obs;
  final tottalTime = Duration().obs;

  final randoIndex = Random();

  RxBool isplay = false.obs;
  RxInt nextIndex = 0.obs;
  RxInt backIndex = 0.obs;

  RxBool isRepet = false.obs;
  RxBool isrendom = false.obs;

  int get randomnInt => randoIndex.nextInt(songs.length);

  RxDouble valueVolum = 0.5.obs;
  RxDouble speedSongValue = 1.0.obs;

  RxList savepositsionlist = [].obs;

  // ------------------------------------------------------------
  // LOAD SONGS
  // ------------------------------------------------------------

  Future<void> loadSongs() async {
    final permission = await audioQuery.permissionsRequest();

    if (!permission) {
      return;
    }

    final result = await audioQuery.querySongs();

    songs.assignAll(result);
  }

  // ------------------------------------------------------------
  // RECENTLY SONG
  // ------------------------------------------------------------

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

    if (songRecently.isNotEmpty) {
      final latestSong = songRecentlyStorage.reduce(
        (a, b) => a.lastPlayedAt.isAfter(b.lastPlayedAt) ? a : b,
      );

      final currentIndex = songs.indexWhere(
        (song) => song.id == latestSong.songId,
      );

      if (currentIndex >= 0) {
        currentSong.value = songs[currentIndex];
      }
    }
  }

  // ------------------------------------------------------------
  // PLAY MUSIC
  // ------------------------------------------------------------

  Future<void> playeMusic(String urlmusic) async {
    await audioPlayer.setFilePath(urlmusic);

    final lastPostionSong = storage.box.read("savePostionSing");

    final lastIdSongPstion = storage.box.read("last_id_song");

    if (lastIdSongPstion == currentSong.value?.id &&
        lastPostionSong != null &&
        lastPostionSong > 0) {
      await audioPlayer.seek(Duration(milliseconds: lastPostionSong));
    }

    await audioPlayer.play();

    isplay.value = true;
  }
  // ------------------------------------------------------------
  // PAUSE
  // ------------------------------------------------------------

  Future<void> pussMusic() async {
    await audioPlayer.pause();
    saveCurrentPostion();
    isplay.value = false;
  }
  // ------------------------------------------------------------
  // NEXT SONG
  // ------------------------------------------------------------

  Future<void> nextSong() async {
    if (songs.isEmpty) return;

    final latestSong = songRecentlyStorage.reduce(
      (a, b) => a.lastPlayedAt.isAfter(b.lastPlayedAt) ? a : b,
    );

    final currentIndex = songs.indexWhere(
      (song) => song.id == latestSong.songId,
    );

    await storage.box.write("savePostionSing", 0);

    await storage.box.write("last_id_song", currentSong.value?.id);

    if (isrendom.value) {
      nextIndex.value = randomnInt;
    } else {
      nextIndex.value = currentIndex + 1;
    }

    if (nextIndex.value >= songs.length) {
      nextIndex.value = 0;
    }

    nextAndBackSongMusic.value = songs[nextIndex.value];

    currentSong.value = nextAndBackSongMusic.value;

    addRecentlySong(nextAndBackSongMusic.value!.id);

    await audioPlayer.stop();

    await playeMusic(nextAndBackSongMusic.value!.data);
  }

  // ------------------------------------------------------------
  // BACK SONG
  // ------------------------------------------------------------

  Future<void> backSong() async {
    if (songs.isEmpty) return;

    final latestSong = songRecentlyStorage.reduce(
      (a, b) => a.lastPlayedAt.isAfter(b.lastPlayedAt) ? a : b,
    );

    final currentIndex = songs.indexWhere(
      (song) => song.id == latestSong.songId,
    );

    backIndex.value = currentIndex - 1;

    await storage.box.write("savePostionSing", 0);

    await storage.box.write("last_id_song", currentSong.value?.id);

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

  // ------------------------------------------------------------
  // PLAYER LISTENERS
  // ------------------------------------------------------------

  void initplayer() {
    // Position
    audioPlayer.positionStream.listen((position) {
      friesTime.value = position;
    });

    // Duration
    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        tottalTime.value = duration;
      }
    });

    // Player state
    audioPlayer.playerStateStream.listen((state) async {
      // وضعیت پخش
      isplay.value = state.playing;

      // وقتی آهنگ کامل شد
      if (state.processingState == ProcessingState.completed) {
        if (isRepet.value) {
          await playeMusic(currentSong.value!.data);
        } else {
          await nextSong();

          await storage.box.write("savePostionSing", 0);

          await storage.box.write("last_id_song", currentSong.value?.id);
        }
      }
    });
  }

  // ------------------------------------------------------------
  // FAVORITE
  // ------------------------------------------------------------

  Future<void> toggleFavorite(int songid) async {
    final index = favoriteSongs.indexWhere((song) => song.songId == songid);

    if (index >= 0) {
      favoriteSongs.removeAt(index);
    } else {
      favoriteSongs.add(ModelFavoriteSongs(isFavorite: true, songId: songid));
    }

    await saveToFavorite();
  }

  Future<void> saveToFavorite() async {
    final data = favoriteSongs.map((song) {
      return song.tostring();
    }).toList();

    await storage.saveFavorite(data);
  }

  // ------------------------------------------------------------
  // VOLUME
  // ------------------------------------------------------------

  Future<void> volumSong() async {
    await audioPlayer.setVolume(valueVolum.value);
  }

  // ------------------------------------------------------------
  // SPEED
  // ------------------------------------------------------------

  Future<void> speedSong() async {
    await audioPlayer.setSpeed(speedSongValue.value);
  }

  // ------------------------------------------------------------
  // SAVE POSITION
  // ------------------------------------------------------------

  Future<void> saveCurrentPostion() async {
    final position = audioPlayer.position;
    if (currentSong.value != null) {
      await storage.box.write("savePostionSing", position.inMilliseconds);

      await storage.box.write("last_id_song", currentSong.value!.id);
    }
  }

  Future<void> resetCurrentPostion() async {
    if (currentSong.value != null) {
      await storage.box.write("savePostionSing", 0);
      await storage.box.write("last_id_song", currentSong.value!.id);
    }
  }

  @override
  void onInit() {
    super.onInit();

    loadRecentlyData();

    initplayer();
  }

  // ------------------------------------------------------------
  // ON CLOSE
  // ------------------------------------------------------------

  @override
  void onClose() async {
    await saveCurrentPostion();

    await audioPlayer.dispose();

    super.onClose();
  }
}
