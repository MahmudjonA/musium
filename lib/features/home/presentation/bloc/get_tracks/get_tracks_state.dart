import 'package:musium/features/home/domain/entities/music.dart';

abstract class GetMusicState {
  const GetMusicState();
}

class GetMusicInitial extends GetMusicState {}

class GetMusicLoading extends GetMusicState {}

class GetMusicSuccess extends GetMusicState {
  final List<Music> tracks;

  const GetMusicSuccess({required this.tracks});
}

class GetMusicError extends GetMusicState {
  final String message;

  const GetMusicError({required this.message});
}
