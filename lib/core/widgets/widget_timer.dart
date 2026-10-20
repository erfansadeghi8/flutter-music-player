import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:music_player/core/services/notifcation_service.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';

class WidgetTimer extends GetxController {
  Timer? _timer;
  final SongController songController = Get.find<SongController>();

  final isTimerRunning = false.obs;
  int hourValue = 0;
  int minuteValue = 0;
  RxInt total = 0.obs;
  int initialTotal = 0;
  RxDouble progress = 0.0.obs;
  RxDouble timeAll = 0.0.obs;
  RxInt hour = 0.obs;
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;
  RxString totalTime = "".obs;
  int selectedTotal = 0;
  RxBool isActiveTimer = false.obs;
  RxString hourString = "00".obs;
  RxString minutesString = "00".obs;
  RxString secondsString = "00".obs;
  RxBool isRun = false.obs;

  void timerPusseMusic(int hour, int minute) {
    if (!isTimerRunning.value) {
      hourValue = hour * 60 * 60;
      minuteValue = minute * 60;
      selectedTotal = (hour * 60 * 60) + (minute * 60);
      initialTotal = hourValue + minuteValue;
      total.value = initialTotal;
    }
  }

  void start() {
    isRun.value = true;
    if (!isTimerRunning.value) {
      if (total.value == 0 || total.value > selectedTotal) {
        initialTotal = selectedTotal;
        total.value = selectedTotal;
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        total.value--;
        progress.value = (initialTotal - total.value) / initialTotal;
        hour.value = total.value ~/ 3600;
        minutes.value = (total.value % 3600) ~/ 60;
        seconds.value = total.value % 60;
        hourString.value = hour.value.toString().padLeft(2, '0');
        minutesString.value = minutes.value.toString().padLeft(2, '0');
        secondsString.value = seconds.value.toString().padLeft(2, '0');
        NotificationService.ShowSleepTimer(
          remainingTime:
              '${hourString.value} : ${minutesString.value} : ${secondsString.value}',
        );
        // ignore: avoid_print
        if (total <= 0) {
          timer.cancel();
          isRun.value = false;
          // Timer تمام شده
          isTimerRunning.value = false;
          isActiveTimer.value = false;
          reset();
          songController.pussMusic();
          SystemNavigator.pop();
        }
      });
    }
    isTimerRunning.value = true;
    isActiveTimer.value = true;
  }

  void stop() async {
    if (isTimerRunning.value) {
      _timer?.cancel();
      isTimerRunning.value = false;
    }
    if (selectedTotal == 0) {
      isRun.value = false;
    }
    isTimerRunning.value = false;
    await NotificationService.cancelSleepTimer();
  }

  void reset() {
    progress.value = 0;
    hour.value = 0;
    minutes.value = 0;
    isRun = false.obs;
    total.value = 0;
    hourString.value = "00";
    minutesString.value = "00";
    secondsString.value = "00";
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
