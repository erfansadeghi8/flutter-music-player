import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/search/searchController/search_controller.dart';

class FormFiedSearch extends StatelessWidget {
  FormFiedSearch({super.key});
  final controller = Get.put(SearchPageController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formkey,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextFormField(
          controller: controller.controllersearch,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Search songs, artists,allbums...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
