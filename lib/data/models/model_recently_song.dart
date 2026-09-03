class ModelRecentlySong {
  int songId;
  DateTime lastPlayedAt;

  ModelRecentlySong({required this.songId, required this.lastPlayedAt});

  factory ModelRecentlySong.fromJson(Map<dynamic, dynamic> json) {
    return ModelRecentlySong(
      songId: json["songId"],
      lastPlayedAt: DateTime.parse(json["lastPlayedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"songId": songId, "lastPlayedAt": lastPlayedAt.toIso8601String()};
  }
}
