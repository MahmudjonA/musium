import 'dart:io';
import 'package:musium/features/home/data/models/category_model.dart';
import 'package:musium/features/home/data/models/genres_model.dart';
import 'package:musium/features/home/data/models/music_model.dart';
import 'package:musium/features/home/data/models/recent_track_model.dart';
import 'package:musium/features/home/domain/entities/recent_tracks.dart';
import '../../domain/repositories/home_repo.dart';
import '../data_sources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl({required this.homeRemoteDataSource});

  @override
  Future<List<CategoryModel>> getCategories() async {
    return await homeRemoteDataSource.getCategories();
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    return await homeRemoteDataSource.getGenres();
  }

  @override
  Future<void> addTrack(MusicModel music) async {
    return await homeRemoteDataSource.addTrack(music);
  }

  @override
  Future<Map<String, dynamic>> addTrackToStorage(File file) async {
    return await homeRemoteDataSource.addTrackToStorage(file);
  }

  @override
  Future<List<MusicModel>> getTracks({required int? playlistId}) async {
    return await homeRemoteDataSource.getTracks(playlistId: playlistId);
  }

  @override
  Future<void> addRecentTrack(RecentTrackModel recentTrack) async {
    return await homeRemoteDataSource.addRecentTrack(recentTrack);
  }

  @override
  Future<List<RecentTracks>> getRecentTracks({required int? limit}) async {
    return await homeRemoteDataSource.getRecentTracks(limit: limit);
  }
}
