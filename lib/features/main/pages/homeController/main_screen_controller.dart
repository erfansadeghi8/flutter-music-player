import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:music_player/home/home_page.dart';
import 'package:music_player/library/Library_page.dart';
import 'package:music_player/playlist/PlayList_page.dart';
import 'package:music_player/search/Search_page.dart';

class MainController extends GetxController {
  RxInt selectedIndexListSong = 0.obs;
  RxBool isplay = false.obs;
  RxInt selectedNavbar = 0.obs;

  List<Widget> listnavbar = [
    HomePage(),
    SearchPage(),
    LibraryPage(),
    PlaylistPage(),
  ];
}
