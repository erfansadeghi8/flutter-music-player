import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/core/theme/app_theme_extension.dart';
import 'package:music_player/core/widgets/widget_timer.dart';
import 'package:music_player/features/main/pages/mainScreenController/main_screen_controller.dart';
import 'package:music_player/features/main/widgets/about_app.dart';
import 'package:music_player/features/main/widgets/show_modal_timer.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final controller = Get.find<MainController>();
  final controllerWidgetTimer = Get.put(WidgetTimer());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: double.infinity,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(
              context,
            ).extension<AppThemeExtension>()!.backgroundGradient,
          ),
        ),
        child: Obx(() {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              //Title placement area in the sidebar
              ListBody(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Stteing",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close_outlined, size: 20),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "General",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //App theme placement
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color.fromARGB(75, 201, 201, 201),
                  collapsedBackgroundColor: const Color.fromARGB(
                    75,
                    201,
                    201,
                    201,
                  ),
                  collapsedIconColor: Theme.of(context).iconTheme.color,
                  iconColor: Theme.of(context).primaryIconTheme.color,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Theme",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "${controller.box.read("Theme")}",
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  leading: Icon(Icons.dark_mode_outlined, size: 30),
                  children: [
                    RadioListTile(
                      title: Text(
                        "system",
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontSize: 18),
                      ),
                      // ignore: deprecated_member_use
                      value: ThemeMode.system,
                      // ignore: deprecated_member_use
                      groupValue: controller.selectedmodeTheme.value,
                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        controller.selectedmodeTheme.value = value!;
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        "light",
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontSize: 18),
                      ),
                      // ignore: deprecated_member_use
                      value: ThemeMode.light,
                      // ignore: deprecated_member_use
                      groupValue: controller.selectedmodeTheme.value,
                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        controller.selectedmodeTheme.value = value!;
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        "dark",
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontSize: 18),
                      ),
                      // ignore: deprecated_member_use
                      value: ThemeMode.dark,
                      // ignore: deprecated_member_use
                      groupValue: controller.selectedmodeTheme.value,
                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        controller.selectedmodeTheme.value = value!;
                      },
                    ),
                  ],
                ),
              ),

              ///*/*/*/*/*/*/*/*/*/*/*/*
              //Setting the app language
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color.fromARGB(75, 201, 201, 201),
                  collapsedBackgroundColor: const Color.fromARGB(
                    75,
                    201,
                    201,
                    201,
                  ),
                  collapsedIconColor: Theme.of(context).iconTheme.color,
                  iconColor: Theme.of(context).primaryIconTheme.color,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Language",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "English",
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  leading: Icon(Icons.language, size: 30),
                  children: [
                    RadioListTile(
                      title: Text(
                        "English",
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontSize: 18),
                      ),
                      // ignore: deprecated_member_use
                      value: "English",
                      // ignore: deprecated_member_use
                      // ignore: deprecated_member_use
                    ),
                  ],
                ),
              ),

              ///*/*/*/*/*/*/*/*/***/*/*/ */
              //Activating the timer and setting the timer
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 0, 10),
                child: Text(
                  "Playback",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              //*/*/*/*/*/*/*/**/*/ */
              // swich for i do  active and not active timer
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(73, 175, 175, 175),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          controller.isActiveTimer.value
                              ? Icon(Icons.timer_outlined, size: 25)
                              : Icon(Icons.timer_off_outlined, size: 25),
                          SizedBox(width: 10),
                          Text(
                            "Timer is Active : ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Switch(
                        value: controller.isActiveTimer.value,
                        onChanged: (value) {
                          if (!controller.isActiveTimer.value) {
                            controllerWidgetTimer.stop();
                          }
                          controller.isActiveTimer.value = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              ///*/*/*/*/*/*/*/*/*/*/**/**/*/ */ */
              //Button to enter the timer setting page
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: controller.isActiveTimer.value
                        ? const Color.fromARGB(73, 175, 175, 175)
                        : const Color.fromARGB(34, 211, 209, 209),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.timer, size: 30),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sleep Timer",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                "off",
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      controller.isActiveTimer.value
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  //Modal placement to enter the timer setting page
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: "Timer",
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) {
                                          return ShowModalTimer();
                                        },
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_right_outlined,
                                  size: 35,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              //*/*/*/*/**/*/* */
              // other
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 0, 10),
                child: Text(
                  "Other",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),

              //*/*/*/*/** */
              //link linkdin
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: InkWell(
                  onTap: () {
                    controller.linkdin(
                      "https://www.linkedin.com/in/erfan-sadeghi-dev",
                    );
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(73, 175, 175, 175),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.link, size: 30),
                            SizedBox(width: 10),
                            Text(
                              "Linkdin",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.arrow_right_outlined, size: 35),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //**/*/*/*/*/ */
              //About App
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: InkWell(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Timer",
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return AboutApp();
                      },
                    );
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(73, 175, 175, 175),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.mark_as_unread_outlined, size: 30),
                            SizedBox(width: 10),
                            Text(
                              "About",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.arrow_right_outlined, size: 35),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
