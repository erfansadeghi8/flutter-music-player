import 'dart:async';
import 'package:get/get.dart';
import 'package:music_player/core/services/notifcation_service.dart';

class WidgetTimer extends GetxController {
  Timer? _timer;

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
        hour.value.toString().padLeft(2, '0');
        minutes.value.toString().padLeft(2, '0');
        seconds.value.toString().padLeft(2, '0');
        NotificationService.ShowSleepTimer(
          remainingTime: '${hour.value} : ${minutes.value} : ${seconds.value}',
        );
        // ignore: avoid_print
        if (total <= 0) {
          timer.cancel();
          // Timer تمام شده
          isTimerRunning.value = false;
        }
      });
    }
    isTimerRunning.value = true;
  }

  void stop() {
    if (isTimerRunning.value) {
      _timer?.cancel();
    }
    isTimerRunning.value = false;
  }

  void reset() {
    if (!isTimerRunning.value) {
      total.value = initialTotal;
      progress.value = 0;
      minutes.value = 0;
      seconds.value = 0;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
