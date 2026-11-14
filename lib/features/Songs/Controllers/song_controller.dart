// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/services/lyra_audio_handler.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/data/models/folder_mode.dart';
import 'package:music_player/data/models/model_favorite_songs.dart';
import 'package:music_player/data/models/model_recently_song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SongController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();

  final songs = <SongModel>[].obs;
  final songRecently = <SongModel>[].obs;
  final songRecentlyStorage = <ModelRecentlySong>[].obs;
  final favoriteSongs = <ModelFavoriteSongs>[].obs;

  final storage = Storage();

  // Single shared AudioPlayer instance owned by LyraAudioHandler
  LyraAudioHandler get lyraHandler => Get.find<LyraAudioHandler>();

  AudioPlayer get audioPlayer => lyraHandler.player;

  final Rxn<SongModel> currentSong = Rxn<SongModel>();
  final Rxn<SongModel> nextAndBackSongMusic = Rxn<SongModel>();

  // Current playlist for folder-specific playback
  final RxList<SongModel> currentPlaylist = <SongModel>[].obs;
  final RxInt currentPlaylistIndex = 0.obs;

  final friesTime = Duration().obs;
  final tottalTime = Duration().obs;

  final randoIndex = Random();

  RxBool isplay = false.obs;
  RxInt nextIndex = 0.obs;
  RxInt backIndex = 0.obs;

  RxBool isRepet = false.obs;
  RxBool isrendom = false.obs;

  int get randomnInt => randoIndex.nextInt(songs.isNotEmpty ? songs.length : 1);

  RxDouble valueVolum = 50.0.obs;
  RxDouble speedSongValue = 1.0.obs;

  RxList savepositsionlist = [].obs;
  bool isChangingSong = false;

  final Map<int, Uint8List?> _artCache = {};
  final Rxn<Uint8List?> currentArt = Rxn<Uint8List?>();

  final RxList<FolderMode> foders = <FolderMode>[].obs;

  // Method to set current playlist (e.g., from a folder)
  void setCurrentPlaylist(List<SongModel> playlist, {int startIndex = 0}) {
    currentPlaylist.assignAll(playlist);
    currentPlaylistIndex.value = startIndex.clamp(0, playlist.length - 1);
  }

  // Clear current playlist (use global songs list)
  void clearCurrentPlaylist() {
    currentPlaylist.clear();
    currentPlaylistIndex.value = 0;
  }

  // Get the effective playlist (current playlist or global songs)
  List<SongModel> get effectivePlaylist =>
      currentPlaylist.isEmpty ? songs : currentPlaylist;
  int get effectiveIndex => currentPlaylist.isEmpty
      ? songs.indexWhere((song) => song.id == currentSong.value?.id)
      : currentPlaylistIndex.value;

  // ------------------------------------------------------------
  // PERMISSIONS & LOAD SONGS
  // ------------------------------------------------------------

  Future<bool> checkAndRequestPermissions() async {
    if (!Platform.isAndroid) return true;

    // Check if permissions are already granted
    if (await Permission.audio.isGranted ||
        await Permission.storage.isGranted) {
      return true;
    }

    // On Android 13+ (SDK 33+), READ_MEDIA_AUDIO is required
    final audioStatus = await Permission.audio.request();
    if (audioStatus.isGranted) {
      return true;
    }

    // On Android 12 and below (such as Samsung SM-A307FN running Android 11, API 30)
    // READ_EXTERNAL_STORAGE is required
    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  Future<void> loadSongs() async {
    final permission = await checkAndRequestPermissions();
    if (!permission) {
      return;
    }
    try {
      final result = await audioQuery.querySongs();
      songs.assignAll(result);
      getFolder();
    } catch (_) {}
  }

  // ------------------------------------------------------------
  // RECENTLY SONG & FOLDERS
  // ------------------------------------------------------------

  void getFolder() {
    final Map<String, List<SongModel>> foldermap = {};

    for (final song in songs) {
      final path = song.data.replaceAll("\\", "/");
      final lastSlash = path.lastIndexOf("/");
      if (lastSlash == -1) continue;
      final folderPath = path.substring(0, lastSlash);

      foldermap.putIfAbsent(folderPath, () => []);
      foldermap[folderPath]!.add(song);
    }

    // Assign folders ONCE outside the loop to avoid UI thread freezes
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

  Future<void> loadFavoriteSongs() async {
    final data = storage.readFavoriteSongsList();
    final favoriteList = data.map((song) {
      return ModelFavoriteSongs.fromJson(song);
    }).toList();
    favoriteSongs.assignAll(favoriteList);
  }

  Future<void> loadRecentlyData() async {
    await loadSongs();
    await loadFavoriteSongs();

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

    // Update playlist index if using custom playlist
    if (currentPlaylist.isNotEmpty) {
      final index = currentPlaylist.indexWhere((s) => s.id == song.id);
      if (index >= 0) {
        currentPlaylistIndex.value = index;
      }
    }

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
  }

  // ------------------------------------------------------------
  // NEXT SONG
  // ------------------------------------------------------------

  Future<void> _switchToSong(SongModel song) async {
    final wasPlaying = audioPlayer.playing || isplay.value;

    currentSong.value = song;
    nextAndBackSongMusic.value = song;

    if (currentPlaylist.isNotEmpty) {
      final index = currentPlaylist.indexWhere((s) => s.id == song.id);

      if (index >= 0) {
        currentPlaylistIndex.value = index;
      }
    }

    await storage.box.write("savePostionSing", 0);
    await storage.box.write("last_id_song", song.id);

    addRecentlySong(song.id);

    try {
      // ابتدا آهنگ جدید بارگذاری شود
      await audioPlayer.setFilePath(song.data);

      // جلوگیری از اعمال اطلاعات آهنگ قبلی
      if (currentSong.value?.id != song.id) return;

      // بعد از بارگذاری، اطلاعات نوتیفیکیشن به‌روز شود
      await _updateNotification();

      if (wasPlaying) {
        isplay.value = true;
        await audioPlayer.play();
      } else {
        isplay.value = false;
        await audioPlayer.pause();
      }
    } catch (e) {
      isplay.value = false;
      rethrow;
    }
  }

  Future<void> nextSong() async {
    final playlist = effectivePlaylist;
    if (playlist.isEmpty || isChangingSong) return;

    isChangingSong = true;

    try {
      final currentIndex = effectiveIndex;

      if (currentIndex == -1) return;

      if (isrendom.value && playlist.length > 1) {
        int randomIndex;

        do {
          randomIndex = randoIndex.nextInt(playlist.length);
        } while (randomIndex == currentIndex);

        nextIndex.value = randomIndex;
      } else {
        nextIndex.value = (currentIndex + 1) % playlist.length;
      }

      await _switchToSong(playlist[nextIndex.value]);
    } finally {
      isChangingSong = false;
    }
  }

  // ------------------------------------------------------------
  // BACK SONG
  // ------------------------------------------------------------

  Future<void> backSong() async {
    final playlist = effectivePlaylist;
    if (playlist.isEmpty || isChangingSong) return;

    isChangingSong = true;

    try {
      final currentIndex = effectiveIndex;

      if (currentIndex == -1) return;

      backIndex.value = (currentIndex - 1 + playlist.length) % playlist.length;

      await _switchToSong(playlist[backIndex.value]);
    } finally {
      isChangingSong = false;
    }
  }

  // ------------------------------------------------------------
  // PLAYER LISTENERS
  // ------------------------------------------------------------

  void initplayer() {
    isplay.value = audioPlayer.playing;
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
      return song.toJson();
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
    try {
      final bytes = await audioQuery.queryArtwork(
        song.id,
        ArtworkType.AUDIO,
        size: 500,
        quality: 85,
      );
      if (_artCache.length > 50) {
        _artCache.remove(_artCache.keys.first);
      }
      _artCache[song.id] = bytes;
      return bytes;
    } catch (_) {
      return null;
    }
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

    lyraHandler.registerCallbacks(
      onNext: nextSong,
      onPrev: backSong,
      onPause: pussMusic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadRecentlyData();
    });

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
    try {
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
    } catch (_) {
      return null;
    }
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
    super.onClose();
  }
}
