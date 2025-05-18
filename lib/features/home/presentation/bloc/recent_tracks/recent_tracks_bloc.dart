import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/features/home/domain/use_cases/add_recent_tracks_use_case.dart';
import 'package:musium/features/home/presentation/bloc/category_event.dart';
import 'package:musium/features/home/presentation/bloc/recent_tracks/recent_tracks_state.dart';

import '../../../domain/use_cases/get_recent_tracks_use_case.dart';

class RecentTrackBloc extends Bloc<HomeEvent, RecentTrackState> {
  final AddRecentTracksUseCase addTrackUseCase;
  final GetRecentTracksUseCase getRecentTracksUseCase;

  RecentTrackBloc(this.addTrackUseCase, this.getRecentTracksUseCase)
    : super(RecentTrackInitial()) {
    on<GetRecentTracksEvent>((event, emit) async {
      emit(RecentTrackLoading());
      try {
        final tracks = await getRecentTracksUseCase(limit: event.limit);
        emit(RecentTrackLoaded(tracks));
      } catch (e) {
        emit(RecentTrackError(e.toString()));
      }
    });

    on<AddRecentTrackEvent>((event, emit) async {
      emit(RecentTrackAdding());
      try {
        await addTrackUseCase(event.recentTracks);
        emit(RecentTrackAdded());
        add(GetRecentTracksEvent());
      } catch (e) {
        emit(RecentTrackError(e.toString()));
      }
    });
  }
}
