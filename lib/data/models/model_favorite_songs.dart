class ModelFavoriteSongs {
  int songId;
  bool isFavorite;

  ModelFavoriteSongs({required this.isFavorite, required this.songId});
  factory ModelFavoriteSongs.fromJson(Map<dynamic, dynamic> json) {
    return ModelFavoriteSongs(
      isFavorite: json["isFavorite"],
      songId: json["songId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"songId": songId, "isFavorite": isFavorite};
  }
}
