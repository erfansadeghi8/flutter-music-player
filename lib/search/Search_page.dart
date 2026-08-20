// ignore_for_file: file_names
import 'package:flutter/widgets.dart';
import 'package:music_player/search/widgets/form_fied_search.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SizedBox(height: 10), FormFiedSearch()],
      ),
    );
  }
}
