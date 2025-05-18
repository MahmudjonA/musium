import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/features/auth/presentation/bloc/log_in/log_in_bloc.dart';
import 'package:musium/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:musium/features/home/presentation/bloc/get_tracks/get_tracks_bloc.dart';
import 'package:musium/features/home/presentation/bloc/music/music_bloc.dart';
import 'package:musium/features/home/presentation/bloc/recent_tracks/recent_tracks_bloc.dart';

import 'core/di/service_locator.dart';
import 'features/auth/presentation/bloc/register/register_bloc.dart';
import 'features/home/presentation/bloc/genre/genre_bloc.dart';

class MyBlocProvider extends StatelessWidget {
  const MyBlocProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //* Auth
        BlocProvider<RegisterUserBloc>(
          create: (context) => sl<RegisterUserBloc>(),
        ),
        BlocProvider<LoginUserBloc>(create: (context) => sl<LoginUserBloc>()),
        BlocProvider<GetCategoriesBloc>(
          create: (context) => sl<GetCategoriesBloc>(),
        ),
        BlocProvider<GetGenresBloc>(create: (context) => sl<GetGenresBloc>()),
        BlocProvider<AddMusicBloc>(create: (context) => sl<AddMusicBloc>()),
        BlocProvider<GetTracksBloc>(create: (context) => sl<GetTracksBloc>()),
        BlocProvider<RecentTrackBloc>(
          create: (context) => sl<RecentTrackBloc>(),
        ),
      ],
      child: child,
    );
  }
}
