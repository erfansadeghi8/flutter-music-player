import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:music_player/features/pageWelcom/pageWelcomController/pageWelcomController.dart';

class Pagethree extends StatelessWidget {
  Pagethree({super.key});
  final Pagewelcomcontroller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //The first photo is for me.
        Opacity(
          opacity: controller.opacetyColunm.value,
          child: Transform.translate(
            offset: Offset(0, controller.transleatcolunmImage.value),
            child: Image.asset(
              "assets/imageWelcome/pageThreeImage.png",
              width: double.infinity,
              height: 300,
            ),
          ),
        ),
        SizedBox(height: 10),
        //text
        Opacity(
          opacity: controller.opacetyColunm.value,
          child: Transform.translate(
            offset: Offset(0, controller.transleatcolunmText.value),
            child: SizedBox(
              width: 190,
              child: Text(
                textAlign: TextAlign.center,
                "Welcome to lyra",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        //text
        Opacity(
          opacity: controller.opacetyColunm.value,
          child: Transform.translate(
            offset: Offset(0, controller.transleatcolunmText.value),
            child: SizedBox(
              width: 205,
              child: Text(
                textAlign: TextAlign.center,
                "Play your local music early and enjoy the best experience",
                style: TextStyle(
                  color: const Color.fromARGB(255, 136, 136, 136),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // SizedBox(height: 10),
        //TextFormField for name
        Transform.translate(
          offset: Offset(0, controller.transleatcolunmText.value),
          child: Opacity(
            opacity: controller.opacetyColunm.value,
            child: Form(
              key: controller.formkey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(34, 50, 34, 0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.name,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter your name.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(78, 255, 255, 255),

                        hintText: "What's your name?",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),

                        labelText: "Name",
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF9717D3),
                            width: 2,
                          ),
                        ),

                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),

                        errorStyle: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
