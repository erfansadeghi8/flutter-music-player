import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/core/widgets/custom_cart.dart';
import 'package:music_player/features/Songs/Controllers/song_controller.dart';
import 'package:music_player/routes/router.dart';
import 'package:on_audio_query/on_audio_query.dart';

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

  // Get favorite songs as a list of SongModel
  List<SongModel> getFavoriteSongs() {
    final favoriteIds = songController.favoriteSongs
        .where((fav) => fav.isFavorite)
        .map((fav) => fav.songId)
        .toSet();
    
    return songController.songs
        .where((song) => favoriteIds.contains(song.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: Text(
            "Library",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 20),
          ),
        ),

        Expanded(
          child: Obx(() {
            final folders = songController.foders;
            final favoriteSongs = getFavoriteSongs();
            final hasFavorites = favoriteSongs.isNotEmpty;
            
            return ListView.builder(
              itemCount: folders.length + (hasFavorites ? 1 : 0),
              itemBuilder: (context, index) {
                // Show favorites at the end
                if (hasFavorites && index == folders.length) {
                  return CustomCart(
                    iconList: const Icon(Icons.favorite_rounded, color: Colors.red),
                    textTilte: "Favorites",
                    lengthList: favoriteSongs.length,
                    ontap: () {
                      songController.setCurrentPlaylist(favoriteSongs);
                      Get.toNamed(AppRouter.libraryListPage, arguments: {
                        "name": "Favorites",
                        "songs": favoriteSongs
                      });
                    },
                  );
                }
                
                final folder = folders[index];
                return CustomCart(
                  iconList: Icon(getFolderIcon(folder.name)),
                  textTilte: folder.name,
                  lengthList: folder.songs.length,
                  ontap: () {
                    Get.toNamed(AppRouter.libraryListPage, arguments: {
                      "name": folder.name,
                      "songs": folder.songs
                    });
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
