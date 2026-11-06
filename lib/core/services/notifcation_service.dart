// ignore_for_file: non_constant_identifier_names
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/instance_manager.dart';
import 'package:music_player/core/widgets/widget_timer.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int notificaionId = 1;
  static const String channelId = "sleep_timer_channel";
  static const String channelNmae = "sleep timer";
  static const String description = "Notifications for Lyra sleep timer";
  static const String notifPortName = 'notif_action_port';


  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );

    final receivePort = ReceivePort();
    IsolateNameServer.removePortNameMapping(notifPortName);
    IsolateNameServer.registerPortWithName(receivePort.sendPort, notifPortName);
    receivePort.listen((actionId) => _handleAction(actionId as String?));

    //برای قسمت اجازه دادن اندروید و ایفون که نوتیف میاد برامون
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> ShowSleepTimer({
    //زمان باقی مانده رو از بیرون میگیریم
    required String remainingTime,
  }) async {
    //»شخص کردن تنظیمات نوتیف داخل اندروید
    final androidDetalis = AndroidNotificationDetails(
      channelId,
      channelNmae,
      channelDescription: description,
      //یعنی چقدر نوتیف برای من مهم هست
      importance: Importance.low,
      priority: Priority.low,
      //یعنی نوتیف تا زمانی که من نبندمش بسته نمیشود
      ongoing: true,
      //یعنی وقتی کابر روی نوتیف کلیک کرد اندروید خودش نوتیف رو حذف نکنه میخوام که دست خودم باشه
      autoCancel: false,
      // این برای ابدیت کردن زمان هست
      //باعث میشه با هر بار تغییر زمان و اپدیت کردن گوشی صدا نده و روی ویوره نره
      onlyAlertOnce: true,
      // دکمه های نوتیف اینجا تعریف میشود
      color: Color.fromARGB(255, 17, 17, 17),
      actions: [
        if (Get.put(WidgetTimer()).isTimerRunning.value &&
            Get.put(WidgetTimer()).isRun.value) ...[
          AndroidNotificationAction(
            "stop_timer",
            "STOP",
            showsUserInterface: false,
            cancelNotification: false,
          ),
        ] else ...[
          AndroidNotificationAction(
            "Cancel_timer",
            "Cancel",
            showsUserInterface: false,
            cancelNotification: false,
          ),
          AndroidNotificationAction(
            "run_timer",
            "Run",
            showsUserInterface: false,
            cancelNotification: false,
          ),
        ],
      ],
    );
    //اینجا تعزریف کردم برای اندورید میخوام
    final notificationDetails = NotificationDetails(android: androidDetalis);
    await notificationsPlugin.show(
      id: notificaionId,
      title: "Lyra",
      body: "Sleep Timer : $remainingTime",
      notificationDetails: notificationDetails,
    );
  }

  static Future<void> cancelSleepTimer() async {
    await notificationsPlugin.cancel(id: notificaionId);
  }

  static void onNotificationResponse(NotificationResponse response) {
    _handleAction(response.actionId);
  }

  static void _handleAction(String? actionId) async {
    if (!Get.isRegistered<WidgetTimer>()) return;
    final timer = Get.find<WidgetTimer>();

    if (actionId == "stop_timer") {
      timer.stop();
      await ShowSleepTimer(
        remainingTime:
            '${timer.hourString.value} : ${timer.minutesString.value} : ${timer.secondsString.value}',
      );
    } else if (actionId == "run_timer") {
      timer.start();
      await ShowSleepTimer(
        remainingTime:
            '${timer.hourString.value} : ${timer.minutesString.value} : ${timer.secondsString.value}',
      );
    } else if (actionId == "Cancel_timer") {
      timer.cancellTimer();
    }
  }

}

@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) {
  final SendPort? port = IsolateNameServer.lookupPortByName(
    NotificationService.notifPortName,
  );
  port?.send(response.actionId);
}
