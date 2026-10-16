import 'dart:ui';

import 'package:asset_image_generator/asset_image_generator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:palette_generator/palette_generator.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  RxInt selectedIndexListSong = 0.obs;
  RxInt selectedNavbar = 0.obs;
  RxBool isEqualizer = false.obs;
  RxInt selectedIndexEqualizer = 0.obs;
  Rx<Color> dmoninantColor = Color(0xFF202030).obs;
  Rx<Color> secondaryColor = Color(0xFF202030).obs;

  Future<void> selectedColorImage(String imagePath) async {
    final palate = await PaletteGenerator.fromImageProvider(
      AssetImage(imagePath),
    );
    dmoninantColor.value =
        palate.dominantColor?.color ?? const Color(0xFF202030);

    secondaryColor.value =
        palate.darkMutedColor?.color ?? const Color(0xFF101018);
  }
}
