import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:music_player/home/homeController/home_controller.dart';

class ShowPlayingMusic extends StatelessWidget {
  ShowPlayingMusic({super.key});
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(40, 163, 163, 163),
        ),
        child: Padding(
          padding: EdgeInsets.all(4),
          //row lider
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // row iamge and text
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/RecentlyMusic/imageRecently.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Soyo Your Toors",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "The wooman",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Obx(() {
                  return IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                    ),
                    onPressed: () {
                      controller.isplay.value = !controller.isplay.value;
                    },
                    icon: controller.isplay.value
                        ? Icon(Icons.play_arrow_outlined, size: 40)
                        : Icon(Icons.pause_outlined, size: 40),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
