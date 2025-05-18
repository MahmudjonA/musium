import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/features/home/domain/use_cases/get_tracks_use_case.dart';
import 'package:musium/features/home/presentation/bloc/get_tracks/get_tracks_state.dart';
import '../category_event.dart';

class GetTracksBloc extends Bloc<HomeEvent, GetMusicState> {
  final GetTracksUseCase getTracksUseCase;

  GetTracksBloc(this.getTracksUseCase) : super(GetMusicInitial()) {
    on<GetTracksEvent>(onGetTracks);
  }

  Future<void> onGetTracks(event, emit) async {
    emit(GetMusicLoading());
    try {
      final tracks = await getTracksUseCase(event.playlistId);
      emit(GetMusicSuccess(tracks: tracks));
    } catch (e) {
      emit(GetMusicError(message: e.toString()));
    }
  }
}
