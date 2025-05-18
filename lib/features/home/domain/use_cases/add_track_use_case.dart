import 'package:musium/features/home/data/models/music_model.dart';
import 'package:musium/features/home/domain/repositories/home_repo.dart';

class AddTrackUseCase {
  final HomeRepo homeRepo;

  AddTrackUseCase(this.homeRepo);

  Future<void> call(MusicModel music) async {
    await homeRepo.addTrack(music);
  }
}
