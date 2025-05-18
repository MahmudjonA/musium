import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/features/home/domain/use_cases/genres_use_case.dart';

import '../category_event.dart';
import 'genre_state.dart';

class GetGenresBloc extends Bloc<HomeEvent, GenreState> {
  final GenresUseCase getGenresUseCase;

  GetGenresBloc(this.getGenresUseCase) : super(GenreInitial()) {
    on<GetGenresEvent>(onGetGenres);
  }

  Future<void> onGetGenres(event, emit) async {
    emit(GenreLoading());
    try {
      final genres = await getGenresUseCase();
      emit(GenreSuccess(genres: genres));
    } catch (e) {
      emit(GenreError(message: e.toString()));
    }
  }
}
