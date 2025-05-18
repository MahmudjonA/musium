import 'package:musium/features/home/domain/entities/recent_tracks.dart';
import 'package:musium/features/home/domain/repositories/home_repo.dart';

class GetRecentTracksUseCase {
  final HomeRepo repository;

  GetRecentTracksUseCase(this.repository);

  Future<List<RecentTracks>> call({required int? limit}) async {
    return await repository.getRecentTracks(limit: limit);
  }
}
