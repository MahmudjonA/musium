import 'package:musium/features/home/domain/entities/music.dart';
import 'package:musium/features/home/domain/repositories/home_repo.dart';

class GetTracksUseCase {
  final HomeRepo repository;

  GetTracksUseCase(this.repository);

  Future<List<Music>> call(int? playlistId) async {
    return await repository.getTracks(playlistId: playlistId);
  }
}
