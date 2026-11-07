import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Icon iconList;
  final String textTilte;
  final int lengthList;
  final VoidCallback? ontap;
  const CustomCart({
    super.key,
    required this.iconList,
    required this.textTilte,
    required this.lengthList,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onTap: ontap,
        child: Container(
          alignment: Alignment.center,
          height: 80,
          decoration: BoxDecoration(
            color: const Color.fromARGB(123, 0, 56, 58),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(54, 68, 137, 255),
                  ),
                  child: iconList,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        textTilte,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "$lengthList Songs",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_right, size: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
