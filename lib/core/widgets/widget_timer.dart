import 'dart:async';

import 'package:get/get.dart';

class WidgetTimer extends GetxController {
  Timer? _timer;

  final isTimerRunning = false.obs;

  void timerPusseMusic(int hour, int minute) {
    int hourValue = hour * 60 * 60;
    int minuteValue = minute * 60;

    int total = hourValue + minuteValue;

    // Timer شروع شده
    isTimerRunning.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      total--;

      print(total);

      if (total <= 0) {
        timer.cancel();

        // Timer تمام شده
        isTimerRunning.value = false;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
