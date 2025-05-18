import 'package:musium/features/home/data/models/recent_track_model.dart';
import 'package:musium/features/home/domain/entities/recent_tracks.dart';
import 'package:musium/features/home/domain/repositories/home_repo.dart';

class AddRecentTracksUseCase {
  final HomeRepo repository;

  AddRecentTracksUseCase(this.repository);

  Future<void> call(RecentTrackModel track) async {
    await repository.addRecentTrack(track);
  }
}
