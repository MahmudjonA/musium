import 'package:musium/features/home/domain/entities/recent_tracks.dart';

abstract class RecentTrackState {}

class RecentTrackInitial extends RecentTrackState {}

class RecentTrackLoading extends RecentTrackState {}

class RecentTrackLoaded extends RecentTrackState {
  final List<RecentTracks> recentTracks;

  RecentTrackLoaded(this.recentTracks);
}

class RecentTrackError extends RecentTrackState {
  final String message;

  RecentTrackError(this.message);
}

class RecentTrackAdding extends RecentTrackState {}

class RecentTrackAdded extends RecentTrackState {}
