import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TitleAllSongs extends StatelessWidget {
  const TitleAllSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("All Songs", style: Theme.of(context).textTheme.labelMedium),
        TextButton(
          onPressed: () {
            print("ok1");
          },
          child: Text("See All", style: Theme.of(context).textTheme.titleSmall),
        ),
      ],
    );
  }
}
