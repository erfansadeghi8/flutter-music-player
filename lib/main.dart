import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_player/core/services/lyra_audio_handler.dart';
import 'package:music_player/core/services/notifcation_service.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/core/theme/themeCustomer.dart';
import 'package:music_player/core/widgets/widget_timer.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:music_player/routes/Pages.dart';
import 'package:music_player/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  lyraHandler = await AudioService.init(
    builder: () => LyraAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.lyra.channel.audio',
      androidNotificationChannelName: 'Lyra Music Player',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidResumeOnClick: true,
      androidShowNotificationBadge: true,
    ),
  );

  Get.put<LyraAudioHandler>(lyraHandler, permanent: true);
  Get.put(WidgetTimer(), permanent: true);

  await NotificationService.initialize();

  final initialRoute = Storage().isFoundName()
      ? AppRouter.mainscreen
      : AppRouter.welcomepage;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    
    return Obx(() {
      return GetMaterialApp(
        initialRoute: initialRoute,
        getPages: AppPages.pages,
        debugShowCheckedModeBanner: false,
        theme: ThemeCustomer().themelightMode,
        darkTheme: ThemeCustomer().themedartMode,
        themeMode: controller.selectedmodeTheme.value,
      );
    });
  }
}
