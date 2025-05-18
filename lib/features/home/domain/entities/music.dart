class Music {
  final int? id;
  final String trackName;
  final String trackArtist;
  final int duration;
  final String imageUrl;
  final String audioUrl;
  final String userId;
  final int playlistId;

  Music({
     this.id,
    required this.trackName,
    required this.trackArtist,
    required this.duration,
    required this.imageUrl,
    required this.audioUrl,
    required this.userId,
    required this.playlistId,
  });
}
