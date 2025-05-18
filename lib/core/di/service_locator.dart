import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musium/features/auth/presentation/bloc/log_in/log_in_bloc.dart';
import 'package:musium/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:musium/features/home/domain/use_cases/category_use_case.dart';
import 'package:musium/features/home/presentation/bloc/music/music_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/data_sources/local/auth_local_data_source.dart';
import '../../features/auth/data/data_sources/local/auth_local_remote_data_source_impl.dart';
import '../../features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import '../../features/auth/data/data_sources/remote/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/use_cases/log_in_user_use_case.dart';
import '../../features/auth/domain/use_cases/register_user_use_case.dart';
import '../../features/auth/presentation/bloc/register/register_bloc.dart';
import '../../features/home/data/data_sources/home_remote_data_source_impl.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repo.dart';
import '../../features/home/domain/use_cases/add_recent_tracks_use_case.dart';
import '../../features/home/domain/use_cases/add_track_to_storage_use_case.dart';
import '../../features/home/domain/use_cases/add_track_use_case.dart';
import '../../features/home/domain/use_cases/genres_use_case.dart';
import '../../features/home/domain/use_cases/get_recent_tracks_use_case.dart';
import '../../features/home/domain/use_cases/get_tracks_use_case.dart';
import '../../features/home/presentation/bloc/category/category_bloc.dart';
import '../../features/home/presentation/bloc/genre/genre_bloc.dart';
import '../../features/home/presentation/bloc/get_tracks/get_tracks_bloc.dart';
import '../../features/home/presentation/bloc/recent_tracks/recent_tracks_bloc.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  await Supabase.initialize(
    url: 'https://nuflijkwasmycnqiurrk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im51Zmxpamt3YXNteWNucWl1cnJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNDYwMTAsImV4cCI6MjA2MjYyMjAxMH0.Ve1DXkuHVnNmHY6PrIL_CtQKmcWw09gx-rNU7SltqHc',
  );
  //! Hive
  await Hive.initFlutter();
  final authBox = await Hive.openBox('authBox');
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(authBox),
  );

  //! Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: Supabase.instance.client),
  );

  // * Home
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  //! Repositories
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl()),
  );
  // * Home
  sl.registerLazySingleton<HomeRepo>(
    () => HomeRepositoryImpl(homeRemoteDataSource: sl()),
  );

  //! Use cases
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => LogInUserUseCase(sl()));
  // * Home
  sl.registerLazySingleton(() => CategoryUseCase(sl()));
  sl.registerLazySingleton(() => GenresUseCase(sl()));
  sl.registerLazySingleton(() => AddTrackUseCase(sl()));
  sl.registerLazySingleton(() => AddTrackToStorageUseCase(sl()));
  sl.registerLazySingleton(() => GetTracksUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentTracksUseCase(sl()));
  sl.registerLazySingleton(() => AddRecentTracksUseCase(sl()));

  //! Bloc
  sl.registerLazySingleton(() => RegisterUserBloc(sl()));
  sl.registerLazySingleton(() => LoginUserBloc(sl()));
  // * Home
  sl.registerLazySingleton(() => GetCategoriesBloc(sl()));
  sl.registerLazySingleton(() => GetGenresBloc(sl()));
  sl.registerLazySingleton(() => AddMusicBloc(sl(), sl()));
  sl.registerLazySingleton(() => GetTracksBloc(sl()));
  sl.registerLazySingleton(() => RecentTrackBloc(sl(), sl()));
}
