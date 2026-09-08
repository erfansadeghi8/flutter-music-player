import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/home/homeController/home_controller.dart';

class ModalControlVoiceSong extends StatelessWidget {
  ModalControlVoiceSong({super.key});
  final controllerHomePage = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Equalizer",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Switch(
                    value: controllerHomePage.isEqualizer.value,
                    onChanged: (value) {
                      controllerHomePage.isEqualizer.value = value;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: AppSize.height(context) * 0.45,
              child: Row(
                children: [
                  // ---------------- مقدارهای سمت چپ ----------------
                  SizedBox(
                    width: 45,
                    height: AppSize.height(context) * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("+10dB"), Text("0dB"), Text("-10dB")],
                    ),
                  ),

                  // ---------------- اسلایدرها ----------------
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 60Hz
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: context.height * 0.4,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    value: 5.0,
                                    min: -10.0,
                                    max: 10.0,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text("60Hz"),
                          ],
                        ),
                        // 230Hz
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: context.height * 0.4,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    value: 2.0,
                                    min: -10.0,
                                    max: 10.0,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text("230Hz"),
                          ],
                        ),

                        // 910Hz
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: context.height * 0.4,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    value: 7.0,
                                    min: -10.0,
                                    max: 10.0,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text("910Hz"),
                          ],
                        ),

                        // 3.6kHz
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: context.height * 0.4,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    value: 2.0,
                                    min: -10.0,
                                    max: 10.0,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text("3.6kHz"),
                          ],
                        ),

                        // 14kHz
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: context.height * 0.4,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    value: 2.0,
                                    min: -10.0,
                                    max: 10.0,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text("14kHz"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0),
            SizedBox(
              height: 100,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          controllerHomePage.selectedIndexEqualizer.value =
                              index;
                        },
                        child: Container(
                          width: AppSize.wdith(context) / 7,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                controllerHomePage
                                        .selectedIndexEqualizer
                                        .value ==
                                    index
                                ? const Color.fromARGB(255, 169, 19, 255)
                                : const Color.fromARGB(255, 75, 75, 75),
                          ),
                          child: Center(
                            child: Text(
                              "Pop",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall!
                                  .copyWith(
                                    color:
                                        controllerHomePage
                                                .selectedIndexEqualizer
                                                .value ==
                                            index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "volume",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                        width: 200,
                        child: RotatedBox(
                          quarterTurns: 4,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                              value: 5.0,
                              min: -10.0,
                              max: 10.0,
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "100",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "volume",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                        width: 200,
                        child: RotatedBox(
                          quarterTurns: 4,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                              value: 5.0,
                              min: -10.0,
                              max: 10.0,
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "100",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
