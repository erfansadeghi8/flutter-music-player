import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  RxInt selectedIndexListSong = 0.obs;
  RxBool isplay = false.obs;
  RxInt selectedNavbar = 0.obs;

  final storage = GetStorage();
}
