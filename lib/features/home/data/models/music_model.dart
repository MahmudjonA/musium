import 'package:musium/features/home/domain/entities/music.dart';

class MusicModel extends Music {
  MusicModel({
    required super.audioUrl,
    super.id,
    required super.trackName,
    required super.trackArtist,
    required super.duration,
    required super.imageUrl,
    required super.userId,
    required super.playlistId,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'],
      trackName: json['track_name'],
      trackArtist: json['track_artist_name'],
      duration: json['duration'],
      imageUrl: json['image_path'],
      audioUrl: json['track_path'],
      userId: json['user_id'],
      playlistId: json['playlist_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'track_path': audioUrl,
      'track_name': trackName,
      'track_artist_name': trackArtist,
      'duration': duration,
      'image_path': imageUrl,
      'user_id': userId,
      'playlist_id': playlistId,
    };
  }
}
