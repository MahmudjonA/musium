import 'package:musium/features/home/domain/repositories/home_repo.dart';

import '../entities/genres.dart';

class GenresUseCase {
  final HomeRepo genresRepository;

  GenresUseCase(this.genresRepository);

  Future<List<Genre>> call() async {
    return await genresRepository.getGenres();
  }
}
