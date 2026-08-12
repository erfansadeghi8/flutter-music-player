// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:music_player/core/widgets/splashScreen/splashScreenController/splashScreenController.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Placing an icon for Lodygin
            Image.asset(
              "assets/icon/icon_app.png",
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            //Placement
            Text(
              "Lyia",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            //Placing the loading app
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
