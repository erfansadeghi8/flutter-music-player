import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

class MusicAnimationWidgetController extends GetxController {
  final Random _random = Random();

  final bars = <double>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    bars.assignAll(List.generate(7, (_) => 15.0));

    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      bars.value = List.generate(7, (_) => 10 + _random.nextDouble() * 35);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
