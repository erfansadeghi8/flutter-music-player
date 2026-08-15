import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListRecentlyPayed extends StatelessWidget {
  const ListRecentlyPayed({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 187,
      child: InkWell(
        child: ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/RecentlyMusic/imageRecently.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
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
            );
          },
        ),
      ),
    );
  }
}
