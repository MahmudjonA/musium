import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/features/home/data/models/music_model.dart';
import 'package:musium/features/home/domain/use_cases/add_track_use_case.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/use_cases/add_track_to_storage_use_case.dart';
import '../category_event.dart';
import 'music_state.dart';

class AddMusicBloc extends Bloc<HomeEvent, MusicState> {
  final AddTrackUseCase addMusicUseCase;
  final AddTrackToStorageUseCase addTrackToStorageUseCase;

  AddMusicBloc(this.addMusicUseCase, this.addTrackToStorageUseCase)
    : super(MusicInitial()) {
    on<AddMusicToStorageEvent>(onAddMusicToStorage);
    on<AddMusicEvent>(onAddMusic); // <-- добавьте эту строку
  }

  Future<void> onAddMusicToStorage(
    AddMusicToStorageEvent event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());
    try {
      final result = await addTrackToStorageUseCase(event.filePath);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      final music = MusicModel(
        trackName: result['trackName'],
        trackArtist: result['trackArtist'],
        duration: result['duration'],
        imageUrl: result['imageUrl'],
        audioUrl: result['musicUrl'],
        userId: userId,
        playlistId: event.playlistId,
      );
      add(AddMusicEvent(music: music));
    } catch (e) {
      emit(MusicError(message: e.toString()));
    }
  }

  Future<void> onAddMusic(AddMusicEvent event, Emitter<MusicState> emit) async {
    try {
      await addMusicUseCase(event.music);
      emit(MusicSuccess());
    } catch (e) {
      emit(MusicError(message: e.toString()));
    }
  }
}
