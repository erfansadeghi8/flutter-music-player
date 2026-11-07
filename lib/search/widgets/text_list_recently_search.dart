
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:music_player/search/searchController/search_controller.dart';

class TextListRecentlySearch extends StatelessWidget {
  TextListRecentlySearch({super.key});

  final SearchPageController searchPageController =
      Get.find<SearchPageController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recently Searches",
            style: Theme.of(context).textTheme.displaySmall,
          ),

          InkWell(
            onTap: () async {
              await searchPageController.clearAllRecentlySongs();
            },
            child: Text(
              "Clear",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(
                    color: const Color.fromARGB(255, 7, 103, 158),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
