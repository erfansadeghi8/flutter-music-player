// ignore: file_names
// ignore_for_file: unnecessary_import
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/utils.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/theme/app_theme_extension.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';
import 'package:music_player/features/pageWelcom/widgets/bottomNavigationBar.dart';
import 'package:music_player/features/pageWelcom/widgets/indexPageWelcom.dart';
import 'package:music_player/features/pageWelcom/widgets/pageOne.dart';
import 'package:music_player/features/pageWelcom/widgets/pageThree.dart';
import 'package:music_player/features/pageWelcom/widgets/pageTwo.dart';

class PageWelcom extends StatelessWidget {
  PageWelcom({super.key});
  final Pagewelcomcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      //Background color
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(
            context,
          ).extension<AppThemeExtension>()!.backgroundGradient,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              //Positioning the entire animation
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: controller.controlleranimation,
                  builder: (context, child) {
                    return Obx(() {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // page 1
                            if (controller.pageIndex.value == 1) ...[
                              Pageone(),
                            ]
                            //page 2
                            else if (controller.pageIndex.value == 2) ...[
                              Pagetwo(),
                            ],
                            SizedBox(height: AppSize.sizebetweentexts),
                            //page 3
                            if (controller.pageIndex.value == 3) ...[
                              Pagethree(),
                            ],
                          ],
                        ),
                      );
                    });
                  },
                ),
              ),
              //Slider placement
              Positioned(
                top: AppSize.size(context).height * 0.79,
                left: 0,
                right: 0,
                child: Center(child: Indexpagewelcom()),
              ),
              //text "Skip" for go to started
              Positioned(
                top: 30,
                right: 30,
                child: Obx(() {
                  if (controller.pageIndex.value == 3) {
                    return SizedBox.shrink();
                  }
                  return InkWell(
                    onTap: () {
                      controller.pageIndex.value = 3;
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 136, 136, 136),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        //Key to go to the next page
        bottomNavigationBar: BottomNavigationBarwidget(),
      ),
    );
  }
}
