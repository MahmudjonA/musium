import 'dart:io';

import 'package:musium/features/home/data/models/music_model.dart';
import 'package:musium/features/home/data/models/recent_track_model.dart';
import 'package:musium/features/home/domain/entities/category.dart';
import 'package:musium/features/home/domain/entities/genres.dart';
import 'package:musium/features/home/domain/entities/recent_tracks.dart';

import '../entities/music.dart';

abstract class HomeRepo {
  Future<List<Category>> getCategories();

  Future<List<Genre>> getGenres();

  Future<void> addTrack(MusicModel music);

  Future<Map<String, dynamic>> addTrackToStorage(File file);

  Future<List<Music>> getTracks({required int? playlistId});

  Future<void> addRecentTrack(RecentTrackModel recentTrack);

  Future<List<RecentTracks>> getRecentTracks({required int? limit});
}
