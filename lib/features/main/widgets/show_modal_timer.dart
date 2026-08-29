import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/theme/app_theme_extension_timer.dart';
import 'package:music_player/core/widgets/widget_timer.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:numberpicker/numberpicker.dart';

class ShowModalTimer extends StatelessWidget {
  ShowModalTimer({super.key});
  final controller = Get.find<MainController>();
  final controllerWidgetTimer = Get.put(WidgetTimer());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(
            context,
          ).extension<AppThemeExtensionTimer>()!.backgroundGradient,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 0, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, size: 35),
                ),
              ],
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/icon/sleepTimer.png",
              width: 150,
              height: 160,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              "Stop Music After",
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(73, 143, 142, 142),
                ),
                child: Obx(() {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // کپسول پشت مقدار انتخاب شده
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: const Color.fromARGB(23, 252, 251, 251),
                          ),
                        ),
                      ),

                      // Number Pickers
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20),
                          // ---------------- HOURS ----------------
                          NumberPicker(
                            minValue: 0,
                            maxValue: 23,
                            value: controller.hour.value,
                            itemHeight: 80,
                            textStyle: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),

                            selectedTextStyle: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),

                            onChanged: (value) {
                              controller.hour.value = value;
                            },
                          ),

                          // متن Hours
                          Text(
                            "hours",
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),

                          // ---------------- MINUTES ----------------
                          NumberPicker(
                            minValue: 0,
                            maxValue: 59,
                            value: controller.minute.value,

                            itemHeight: 80,

                            textStyle: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),

                            selectedTextStyle: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),

                            onChanged: (value) {
                              controller.minute.value = value;
                            },
                          ),

                          // متن Min
                          Text(
                            "min",
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: AppSize.height(context) / 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: controllerWidgetTimer.isTimerRunning.value
                  ? null
                  : () {
                      controllerWidgetTimer.timerPusseMusic(
                        controller.hour.value,
                        controller.minute.value,
                      );
                    },
              child: Text(
                controllerWidgetTimer.isTimerRunning.value
                    ? 'Timer Running'
                    : 'Start Timer',
              ),
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     throw Exception("Test Crashlytics");
            //   },
            //   child: const Text("Test Crash"),
            // ),
          ],
        ),
      ),
    );
  }
}
