
abstract class MusicState {
  const MusicState();
}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicSuccess extends MusicState {
}

class MusicError extends MusicState {
  final String message;

  const MusicError({required this.message});
}
