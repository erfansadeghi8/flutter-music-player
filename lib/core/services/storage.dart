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
}
