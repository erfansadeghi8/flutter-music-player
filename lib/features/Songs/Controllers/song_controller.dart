// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/lyra_audio_handler.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/data/models/folder_mode.dart';
import 'package:music_player/data/models/model_favorite_songs.dart';
import 'package:music_player/data/models/model_recently_song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

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

  RxDouble valueVolum = 50.0.obs;
  RxDouble speedSongValue = 1.0.obs;

  RxList savepositsionlist = [].obs;
  bool isChangingSong = false;

  final Map<int, Uint8List?> _artCache = {};
  final Rxn<Uint8List?> currentArt = Rxn<Uint8List?>();

  final RxList<FolderMode> foders = <FolderMode>[].obs;

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
    getFolder();
  }

  // ------------------------------------------------------------
  // RECENTLY SONG
  // ------------------------------------------------------------

  void getFolder() {
    final Map<String, List<SongModel>> foldermap = {};

    for (final song in songs) {
      final path = song.data.replaceAll("\\", "/");
      final lastSlash = path.lastIndexOf("/");
      if (lastSlash == -1) continue;
      final folderPath = path.substring(0, lastSlash);
      final folderName = folderPath.substring(folderPath.lastIndexOf("/") + 1);

      foldermap.putIfAbsent(folderPath, () => []);

      foldermap[folderPath]!.add(song);

      foders.assignAll(
        foldermap.entries.map((entry) {
          final path = entry.key;

          return FolderMode(
            name: path.substring(path.lastIndexOf("/") + 1),
            path: path,
            songs: entry.value,
          );
        }).toList(),
      );
    }
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
    sortRecentlySongs();
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
    if (urlmusic.isEmpty) return;

    final selectedSong = songs.firstWhereOrNull(
      (song) => song.data == urlmusic,
    );

    if (selectedSong != null) {
      currentSong.value = selectedSong;
    }

    final song = currentSong.value;
    if (song == null) return;

    // صفر کردن موقعیت فقط برای آهنگ جدید
    final lastPos = storage.box.read("savePostionSing");
    final lastId = storage.box.read("last_id_song");

    Duration? initial;

    if (lastId == song.id && lastPos != null && lastPos > 0) {
      initial = Duration(milliseconds: lastPos);
    }

    // ارسال فوری اطلاعات آهنگ جدید
    await _updateNotification();

    try {
      await audioPlayer.setFilePath(urlmusic, initialPosition: initial);

      // بروزرسانی مدت واقعی آهنگ
      if (currentSong.value?.id == song.id) {
        lyraHandler.setCurrentMediaItem(
          MediaItem(
            id: song.id.toString(),
            title: song.title,
            artist: song.artist ?? 'Unknown Artist',
            album: song.album,
            duration: audioPlayer.duration,
            artUri: lyraHandler.mediaItem.value?.artUri,
          ),
        );
      }

      isplay.value = true;

      unawaited(audioPlayer.play());
    } catch (e) {
      isplay.value = false;
      rethrow;
    }
  }

  // ------------------------------------------------------------
  // PAUSE
  // ------------------------------------------------------------

  Future<void> pussMusic() async {
    await audioPlayer.pause();
    saveCurrentPostion();
    isplay.value = false;
    // sortRecentlySongs();
  }

  // ------------------------------------------------------------
  // NEXT SONG
  // ------------------------------------------------------------

  Future<void> _switchToSong(SongModel song) async {
    final wasPlaying =
        audioPlayer.playing ||
        audioPlayer.processingState == ProcessingState.completed ||
        isplay.value;

    currentSong.value = song;
    nextAndBackSongMusic.value = song;

    // ذخیره موقعیت صفر برای آهنگ جدید
    await storage.box.write("savePostionSing", 0);
    await storage.box.write("last_id_song", song.id);

    addRecentlySong(song.id);

    // ارسال سریع اطلاعات آهنگ
    await _updateNotification();

    try {
      await audioPlayer.setFilePath(song.data);

      if (currentSong.value?.id != song.id) return;

      isplay.value = wasPlaying;

      if (wasPlaying) {
        unawaited(audioPlayer.play());
      } else {
        await audioPlayer.pause();
      }
    } catch (e) {
      isplay.value = false;
      rethrow;
    }
  }

  Future<void> nextSong() async {
    if (songs.isEmpty || isChangingSong) return;

    isChangingSong = true;

    try {
      final currentIndex = songs.indexWhere(
        (song) => song.id == currentSong.value?.id,
      );

      if (currentIndex == -1) return;

      if (isrendom.value && songs.length > 1) {
        int randomIndex;

        do {
          randomIndex = randomnInt;
        } while (randomIndex == currentIndex);

        nextIndex.value = randomIndex;
      } else {
        nextIndex.value = (currentIndex + 1) % songs.length;
      }

      await _switchToSong(songs[nextIndex.value]);
    } finally {
      isChangingSong = false;
    }
  }

  // ------------------------------------------------------------
  // BACK SONG
  // ------------------------------------------------------------

  Future<void> backSong() async {
    if (songs.isEmpty || isChangingSong) return;

    isChangingSong = true;

    try {
      final currentIndex = songs.indexWhere(
        (song) => song.id == currentSong.value?.id,
      );

      if (currentIndex == -1) return;

      backIndex.value = (currentIndex - 1 + songs.length) % songs.length;

      await _switchToSong(songs[backIndex.value]);
    } finally {
      isChangingSong = false;
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

  Future<Uint8List?> _loadArtwork(SongModel song) async {
    if (_artCache.containsKey(song.id)) return _artCache[song.id];
    final bytes = await OnAudioQuery().queryArtwork(
      song.id,
      ArtworkType.AUDIO,
      size: 1000,
      quality: 100,
    );
    _artCache[song.id] = bytes;
    return bytes;
  }

  void sortRecentlySongs() {
    songRecently.sort((a, b) {
      final recordA = songRecentlyStorage.firstWhereOrNull(
        (item) => item.songId == a.id,
      );

      final recordB = songRecentlyStorage.firstWhereOrNull(
        (item) => item.songId == b.id,
      );

      final timeA = recordA?.lastPlayedAt;
      final timeB = recordB?.lastPlayedAt;

      if (timeA == null && timeB == null) return 0;
      if (timeA == null) return 1;
      if (timeB == null) return -1;

      return timeB.compareTo(timeA);
    });

    songRecently.refresh();
  }

  @override
  void onInit() {
    super.onInit();

    initplayer();

    lyraHandler.attach(
      audioPlayer,
      onNext: nextSong,
      onPrev: backSong,
      onPause: pussMusic,
    );

    loadRecentlyData();

    ever(currentSong, (song) async {
      if (song == null) return;

      final bytes = await _loadArtwork(song);

      if (currentSong.value?.id == song.id) {
        currentArt.value = bytes;
      }

      _preloadNeighbors();
    });
  }

  Future<Uri?> _saveArtwork(SongModel song) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/art_${song.id}.jpg');
    if (!await file.exists()) {
      final bytes = await audioQuery.queryArtwork(
        song.id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: 500,
      );
      if (bytes == null) return null;
      await file.writeAsBytes(bytes);
    }
    return file.uri;
  }

  Future<void> _updateNotification() async {
    final song = currentSong.value;
    if (song == null) return;

    final item = MediaItem(
      id: song.id.toString(),
      title: song.title,
      artist: song.artist ?? 'Unknown Artist',
      album: song.album,
      duration:
          audioPlayer.duration ?? Duration(milliseconds: song.duration ?? 0),
    );

    // ارسال فوری اطلاعات
    lyraHandler.setCurrentMediaItem(item);

    // بارگذاری کاور بدون متوقف کردن روند تعویض آهنگ
    unawaited(_updateArtwork(song, item));
  }

  Future<void> _updateArtwork(SongModel song, MediaItem item) async {
    try {
      final artworkUri = await _saveArtwork(song);

      if (artworkUri == null) return;

      if (currentSong.value?.id != song.id) return;

      lyraHandler.setCurrentMediaItem(item.copyWith(artUri: artworkUri));
    } catch (e) {
      // خطای کاور نباید پخش را متوقف کند.
    }
  }

  // بیرون از onInit، به عنوان متد کلاس
  void _preloadNeighbors() {
    final i = songs.indexWhere((s) => s.id == currentSong.value?.id);
    if (i == -1) return;
    for (final j in [i - 1, i + 1]) {
      if (j >= 0 && j < songs.length) _loadArtwork(songs[j]);
    }
  }

  // ------------------------------------------------------------
  // ON CLOSE
  // ------------------------------------------------------------

  @override
  void onClose() {
    unawaited(saveCurrentPostion());
    unawaited(lyraHandler.disposeHandler());
    unawaited(audioPlayer.dispose());

    super.onClose();
  }
}
