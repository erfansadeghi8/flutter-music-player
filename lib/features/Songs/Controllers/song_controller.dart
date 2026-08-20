import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final songs = <SongModel>[].obs;
  final songRecently = <SongModel>[].obs;

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

  @override
  void onInit() {
    super.onInit();
    loadSongs();
  }
}
