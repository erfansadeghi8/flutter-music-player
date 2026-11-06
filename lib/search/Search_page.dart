// ignore_for_file: file_names
import 'package:flutter/widgets.dart';
import 'package:music_player/home/widgets/show_playing_music.dart';
import 'package:music_player/search/widgets/form_fied_search.dart';
import 'package:music_player/search/widgets/list_recently_Search.dart';
import 'package:music_player/search/widgets/list_searching.dart';
import 'package:music_player/search/widgets/text_list_recently_search.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              FormFiedSearch(),
              TextListRecentlySearch(),
              ListRecentlySearch(),
              ShowPlayingMusic(),
            ],
          ),
        ),
        Positioned(top: 80, left: 10, right: 10, child: ListSearching()),
      ],
    );
  }
}
