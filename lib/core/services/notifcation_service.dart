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
  // Use dedicated timer channel to prevent interference with media playback notification
  static const String channelId = "com.lyra.channel.timer";
  static const String channelName = "Lyra Sleep Timer";
  static const String description = "Notifications for Lyra sleep timer";
  static const String notifPortName = 'notif_action_port';

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      const AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings("@mipmap/ic_launcher");

      const InitializationSettings initializationSettings =
          InitializationSettings(android: androidInitializationSettings);

      await notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: onNotificationResponse,
      );

      final receivePort = ReceivePort();
      IsolateNameServer.removePortNameMapping(notifPortName);
      IsolateNameServer.registerPortWithName(
          receivePort.sendPort, notifPortName);
      receivePort.listen((actionId) => _handleAction(actionId as String?));

      // Clear stale sleep-timer notification left from previous app session.
      try {
        await notificationsPlugin.cancel(id: notificaionId);
      } catch (_) {}

      _initialized = true;
    } catch (_) {
      // Avoid crashing app startup if local notifications cannot initialize.
    }
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
      color: const Color.fromARGB(255, 17, 17, 17),
      actions: [
        if (Get.isRegistered<WidgetTimer>() && 
            Get.find<WidgetTimer>().isTimerRunning.value &&
            Get.find<WidgetTimer>().isRun.value) ...[
          const AndroidNotificationAction(
            "stop_timer",
            "STOP",
            showsUserInterface: false,
            cancelNotification: false,
          ),
        ] else ...[
          const AndroidNotificationAction(
            "Cancel_timer",
            "Cancel",
            showsUserInterface: false,
            cancelNotification: false,
          ),
          const AndroidNotificationAction(
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
