import '../../../domain/entities/genres.dart';

abstract class GenreState {
  const GenreState();
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreSuccess extends GenreState {
  final List<Genre> genres;

  const GenreSuccess({required this.genres});
}

class GenreError extends GenreState {
  final String message;

  const GenreError({required this.message});
}
