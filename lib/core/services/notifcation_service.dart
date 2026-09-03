// ignore_for_file: non_constant_identifier_names

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

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
    );

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
    const androidDetalis = AndroidNotificationDetails(
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
      actions: [
        AndroidNotificationAction(
          "stop_timer",
          "STOP",
          // رای زمانی هست که وقتی روی action کلیک شد UI هم درگیر بشه و برنامه باز بشه
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          "run_timer",
          "Run",
          // رای زمانی هست که وقتی روی action کلیک شد UI هم درگیر بشه و برنامه باز بشه
          showsUserInterface: true,
        ),
      ],
    );
    //اینجا تعزریف کردم برای اندورید میخوام
    const notificationDetails = NotificationDetails(android: androidDetalis);

    await notificationsPlugin.show(
      id: notificaionId,
      title: "Lyra",
      body: "Sleep Timer . $remainingTime",
      notificationDetails: notificationDetails,
    );
  }

  static Future<void> cancelSleepTimer() async {
    await notificationsPlugin.cancel(id: notificaionId);
  }

  static void onNotificationResponse(NotificationResponse response) {
    if (response.actionId == "stop_timer") {
      Get.put(WidgetTimer()).stop();
    }
    if (response.actionId == "run_timer") {
      Get.put(WidgetTimer()).start();
    }
  }
}
