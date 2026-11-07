
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/widgets/custom_cart.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';

class LibraryPage extends StatelessWidget {
  LibraryPage({super.key});

  final SongController songController = Get.find<SongController>();

  IconData getFolderIcon(String folderName) {
    final name = folderName.toLowerCase();

    if (name.contains('download')) {
      return Icons.download_rounded;
    } else if (name.contains('music')) {
      return Icons.library_music_rounded;
    } else if (name.contains('bluetooth')) {
      return Icons.bluetooth_rounded;
    } else if (name.contains('telegram')) {
      return Icons.send_rounded;
    } else if (name.contains('whatsapp')) {
      return Icons.chat_rounded;
    } else if (name.contains('record')) {
      return Icons.mic_rounded;
    } else if (name.contains('podcast')) {
      return Icons.podcasts_rounded;
    }

    return Icons.folder_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: Text(
            "LibraryPage",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 20),
          ),
        ),

        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: songController.foders.length,
              itemBuilder: (context, index) {
                final folder = songController.foders[index];

                return CustomCart(
                  iconList: Icon(getFolderIcon(folder.name)),
                  textTilte: folder.name,
                  lengthList: folder.songs.length,
                  ontap: () {
                    print("Selected folder: ${folder.name}");
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
