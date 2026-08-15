import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_player/core/theme/themeCustomer.dart';
import 'package:music_player/routes/Pages.dart';
import 'package:music_player/routes/bilding.dart';
import 'package:music_player/routes/router.dart';

void main(List<String> args) async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: splashScreenPageBilding(),
      initialRoute: AppRouter.splash,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      theme: ThemeCustomer().themelightMode,
      darkTheme: ThemeCustomer().themedartMode,
      themeMode: ThemeMode.system,
      // theme: AppTheme.lightTheme,
    );
  }
}
