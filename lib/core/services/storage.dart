import 'package:get_storage/get_storage.dart';

class Storage {
  final box = GetStorage();

  Future<void> writeName(String name) async {
    await box.write("name", name);
  }

  String readName() {
    return box.read("name");
  }

  bool isFoundName() {
    final userName = box.read("name");
    return userName != null && userName.toString().isNotEmpty;
  }

  // ignore: strict_top_level_inference
  Future<void> saveReently(data) async {
    await box.write("recentlySong", data);
  }

  // ignore: strict_top_level_inference
  Future<void> saveFavorite(data) async {
    await box.write("favoriteSongs", data);
  }

  List readFavoriteSongsList() {
    return box.read("favoriteSongs") ?? [];
  }

  List readSaveRecentlySong() {
    return box.read("recentlySong") ?? [];
  }

  Future<void> saveIsOnEqulauzer(bool isOn) async {
    await box.write("EqualizerOn/Off", isOn);
  }

  bool readIsOnEqualizer() {
    return box.read("EqualizerOn/Off") ?? false;
  }

  Future<void> saveEqualizerPreset(
    String presetName,
    List<int> bandLevels,
  ) async {
    await box.write("equalizerPreset_$presetName", bandLevels);
  }

  List<int>? readEqualizerPreset(String presetName) {
    return box.read("equalizerPreset_$presetName")?.cast<int>();
  }
}
