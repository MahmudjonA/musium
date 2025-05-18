import 'dart:io';

import 'package:musium/features/home/data/models/music_model.dart';
import 'package:musium/features/home/data/models/recent_track_model.dart';
import 'package:musium/features/home/domain/entities/recent_tracks.dart';

abstract class HomeEvent {
  const HomeEvent();
}

// ! Categories
class GetCategoriesEvent extends HomeEvent {
  GetCategoriesEvent();
}

// ! Genres
class GetGenresEvent extends HomeEvent {
  GetGenresEvent();
}

// ! Music
class AddMusicEvent extends HomeEvent {
  final MusicModel music;

  AddMusicEvent({required this.music});
}

class AddMusicToStorageEvent extends HomeEvent {
  final File filePath;
  final int playlistId;

  AddMusicToStorageEvent(this.playlistId, {required this.filePath});
}

class GetTracksEvent extends HomeEvent {
  final int? playlistId;

  GetTracksEvent({required this.playlistId});
}

// ! Recent Tracks
class AddRecentTrackEvent extends HomeEvent {
  final RecentTrackModel recentTracks;

  AddRecentTrackEvent({required this.recentTracks});
}

class GetRecentTracksEvent extends HomeEvent {
  final int? limit;

  GetRecentTracksEvent({this.limit});
}
