import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_player/core/services/lyra_audio_handler.dart';
import 'package:music_player/core/services/notifcation_service.dart';
import 'package:music_player/core/theme/themeCustomer.dart';
import 'package:music_player/core/widgets/widget_timer.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:music_player/routes/Pages.dart';
import 'package:music_player/routes/bilding.dart';
import 'package:music_player/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await GetStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  lyraHandler = await AudioService.init(
    builder: () => LyraAudioHandler(),
    config:  AudioServiceConfig(
      androidNotificationChannelId: 'com.lyra.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: false,
    ),
  );
  Get.put<LyraAudioHandler>(lyraHandler, permanent: true);
  Get.put(WidgetTimer(), permanent: true);
  await NotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        initialBinding: splashScreenPageBilding(),
        initialRoute: AppRouter.splash,
        getPages: AppPages.pages,
        debugShowCheckedModeBanner: false,
        theme: ThemeCustomer().themelightMode,
        darkTheme: ThemeCustomer().themedartMode,
        themeMode: controller.selectedmodeTheme.value,
      );
    });
  }
}
