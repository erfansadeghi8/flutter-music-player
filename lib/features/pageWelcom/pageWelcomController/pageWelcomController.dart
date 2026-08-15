// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:music_player/core/services/storage.dart';

class Pagewelcomcontroller extends GetxController
    with GetSingleTickerProviderStateMixin {
  //Variable for a page welcomm
  RxInt pageIndex = 1.obs;
  // build variable for AnimationController
  late AnimationController controlleranimation;
  // build variable for Animated TranlateImage
  late final Animation<double> transleatcolunmImage;
  // build variable for Animated TranlateText
  late final Animation<double> transleatcolunmText;
  // build variable for Animated opacity
  late final Animation<double> opacetyColunm;

  // build variable for  TextFormField
  late final TextEditingController name = TextEditingController();
  // build variable key  for Form
  final formkey = GlobalKey<FormState>();
  @override
  void onInit() {
    //Setting a time value for an animation variable
    controlleranimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    transleatcolunmImage = Tween<double>(
      begin: -400,
      end: 0,
    ).animate(controlleranimation);

    transleatcolunmText = Tween<double>(
      begin: 600,
      end: 0,
    ).animate(controlleranimation);

    opacetyColunm = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controlleranimation);
    //Running the animation for the first time
    controlleranimation.forward();
    //This function is executed when any change is made to pageIndex and it checks the animation once and runs it again.
    ever<int>(pageIndex, (value) {
      controlleranimation
        ..reset()
        ..forward();
    });
    super.onInit();
  }

  Future<void> saveName() async {
    await Storage().writeName(name.text);
  }

  @override
  void onClose() {
    //By exiting this page, the animation will be completely deleted from memory.
    controlleranimation.dispose();
    super.onClose();
  }
}
