import 'package:musium/features/home/domain/entities/music.dart';

class RecentTracks {
  final int? id;
  final String userId;
  final int musicId;
  final DateTime? createdAt;
  final Music? music;

  RecentTracks({
    this.id,
    this.music,
    required this.userId,
    required this.musicId,
    this.createdAt,
  });
}
