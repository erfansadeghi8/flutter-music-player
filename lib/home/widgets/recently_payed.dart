import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecentlyPayed extends StatelessWidget {
  const RecentlyPayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Recently Played", style: Theme.of(context).textTheme.labelMedium),
        TextButton(
          onPressed: () {
            print("ok");
          },
          child: Text("See All", style: Theme.of(context).textTheme.titleSmall),
        ),
      ],
    );
  }
}
