// ignore_for_file: non_constant_identifier_names
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/instance_manager.dart';
import 'package:music_player/core/services/lyra_audio_handler.dart';
import 'package:music_player/core/widgets/widget_timer.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int notificaionId = 1;
  // Use the same channel as audio_service to avoid duplicate notifications
  static const String channelId = "com.lyra.channel.audio";
  static const String channelName = "Lyra Music Player";
  static const String description = "Notifications for Lyra music playback and sleep timer";
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

    // Request notification permission
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Check if music is currently playing via audio_service
  static bool get _isMusicPlaying {
    try {
      if (Get.isRegistered<LyraAudioHandler>()) {
        final handler = Get.find<LyraAudioHandler>();
        return handler.playbackState.value.playing;
      }
    } catch (_) {}
    return false;
  }
   
  static Future<void> ShowSleepTimer({
    //زمان باقی مانده رو از بیرون میگیریم
    required String remainingTime,
  }) async {
    // Don't show separate sleep timer notification if music is playing
    // The audio_service notification handles playback controls
    if (_isMusicPlaying) {
      return;
    }
    
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: description,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      color: Color.fromARGB(255, 17, 17, 17),
      actions: [
        if (Get.isRegistered<WidgetTimer>() && 
            Get.find<WidgetTimer>().isTimerRunning.value &&
            Get.find<WidgetTimer>().isRun.value) ...[
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
    final notificationDetails = NotificationDetails(android: androidDetails);
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

// Top-level background handler for notification actions (required by flutter_local_notifications)
@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) {
  final notifPortName = 'notif_action_port';
  final receivePort = ReceivePort();
  IsolateNameServer.removePortNameMapping(notifPortName);
  IsolateNameServer.registerPortWithName(receivePort.sendPort, notifPortName);
  receivePort.sendPort.send(response.actionId);
}

