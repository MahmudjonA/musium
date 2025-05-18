import 'dart:io';
import 'package:musium/features/home/data/models/category_model.dart';
import 'package:musium/features/home/data/models/genres_model.dart';
import 'package:musium/features/home/data/models/music_model.dart';

import '../models/recent_track_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<GenreModel>> getGenres();

  Future<void> addTrack(MusicModel music);

  Future<Map<String, dynamic>> addTrackToStorage(File file);

  Future<List<MusicModel>> getTracks({int? playlistId});

  Future<void> addRecentTrack(RecentTrackModel recentTrack);

  Future<List<RecentTrackModel>> getRecentTracks({required int? limit});
}
