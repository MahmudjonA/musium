import 'package:musium/features/home/domain/entities/recent_tracks.dart';

import 'music_model.dart';

class RecentTrackModel extends RecentTracks {
  RecentTrackModel({
    super.id,
    required super.userId,
    required super.musicId,
    super.createdAt,
    super.music,
  });

  factory RecentTrackModel.fromJson(Map<String, dynamic> json) {
    return RecentTrackModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      musicId: json['music_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      music:
          json['music'] != null
              ? MusicModel.fromJson(json['music'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'music_id': musicId};
  }
}
