import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/core/common/colors/app_colors.dart';
import 'package:musium/core/responsiveness/app_responsive.dart';
import 'package:musium/core/route/rout_generator.dart';
import 'package:musium/features/home/presentation/pages/playlist_page.dart';
import 'package:musium/features/home/presentation/pages/song_page.dart';
import 'package:musium/features/home/presentation/widgets/category_wg.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../bloc/category_event.dart';
import '../bloc/genre/genre_bloc.dart';
import '../bloc/genre/genre_state.dart';
import '../bloc/recent_tracks/recent_tracks_bloc.dart';
import '../bloc/recent_tracks/recent_tracks_state.dart';
import '../widgets/top_mixes_wg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetCategoriesBloc>().add(GetCategoriesEvent());
    context.read<GetGenresBloc>().add(GetGenresEvent());
    context.read<RecentTrackBloc>().add(GetRecentTracksEvent(limit: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.grey,
              radius: appH(25),
              child: const Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: appH(15)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: appH(17),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: appH(5)),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: appH(15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.white, size: appH(30)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: appH(20),
          left: appW(20),
          right: appW(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Continue Listening",
              style: TextStyle(
                color: AppColors.white,
                fontSize: appH(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: appH(20)),
            BlocBuilder<GetCategoriesBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is CategorySuccess) {
                  if (state.categories.isEmpty) {
                    return Center(
                      child: Text(
                        'No categories available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: appH(11),
                        crossAxisSpacing: appW(11),
                        childAspectRatio: 2.8,
                      ),
                      itemBuilder: (context, index) {
                        final item = state.categories[index];
                        return CategoryWg(
                          onTap: () {
                            AppRoute.go(PlaylistPage(category: item));
                          },
                          imagePath: item.image,
                          title: item.title,
                        );
                      },
                    );
                  }
                }
                return const SizedBox();
              },
            ),
            SizedBox(height: appH(25)),
            Text(
              "Your Top Mixes",
              style: TextStyle(
                color: AppColors.white,
                fontSize: appH(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: appH(20)),
            SizedBox(
              height: appH(150),
              child: BlocBuilder<GetGenresBloc, GenreState>(
                builder: (context, state) {
                  if (state is GenreLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GenreError) {
                    return Center(child: Text(state.message));
                  } else if (state is GenreSuccess) {
                    final genres = state.genres;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: genres.length,
                      itemBuilder: (context, index) {
                        final item = genres[index];
                        return TopMixesWg(
                          image: item.imagePath,
                          title: item.genre,
                          borderColor: item.color,
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            SizedBox(height: appH(20)),
            Text(
              "Based on your recent listening",
              style: TextStyle(
                color: AppColors.white,
                fontSize: appH(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: appH(20)),
            BlocBuilder<RecentTrackBloc, RecentTrackState>(
              builder: (context, state) {
                if (state is RecentTrackLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RecentTrackError) {
                  return Center(child: Text(state.message));
                } else if (state is RecentTrackLoaded) {
                  final tracks = state.recentTracks;
                  if (tracks.isEmpty) {
                    return Center(
                      child: Text(
                        'No recent tracks',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return SizedBox(
                    height: appH(182),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tracks.length > 5 ? 5 : tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks[index];
                        return GestureDetector(
                          onTap: () {
                            AppRoute.go(SongPage(music: track.music!));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: appW(20)),
                            width: appW(182),
                            height: appH(182),
                            child:
                                track.music != null &&
                                        track.music!.imageUrl != null &&
                                        track.music!.imageUrl!.isNotEmpty
                                    ? Image.network(
                                      track.music!.imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                    : Container(
                                      color: Colors.grey,
                                      child: Center(
                                        child: Icon(
                                          Icons.music_note,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
