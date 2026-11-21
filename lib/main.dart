import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_player/core/services/lyra_audio_handler.dart';
import 'package:music_player/core/services/notifcation_service.dart';
import 'package:music_player/core/services/storage.dart';
import 'package:music_player/core/theme/themeCustomer.dart';
import 'package:music_player/core/widgets/widget_timer.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/main/mainScreenController/main_screen_controller.dart';
import 'package:music_player/routes/Pages.dart';
import 'package:music_player/routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();


  final handler = await AudioService.init(
    builder: () => LyraAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.lyra.channel.audio',
      androidNotificationChannelName: 'Lyra Playback',
      androidStopForegroundOnPause: false,
    ),
  );
  Get.put<LyraAudioHandler>(handler, permanent: true);

  Get.put(SongController(), permanent: true);

  Get.put<WidgetTimer>(WidgetTimer(), permanent: true);
  Get.put<MainController>(MainController(), permanent: true);

  await NotificationService.initialize();

  final initialRoute = Storage().isFoundName()
      ? AppRouter.mainscreen
      : AppRouter.welcomepage;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

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
