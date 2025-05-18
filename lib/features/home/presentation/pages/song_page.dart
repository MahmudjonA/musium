import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/core/common/colors/app_colors.dart';
import 'package:musium/core/responsiveness/app_responsive.dart';
import 'package:musium/features/home/data/models/recent_track_model.dart';
import 'package:musium/features/home/presentation/bloc/recent_tracks/recent_tracks_bloc.dart';
import 'package:musium/features/home/presentation/widgets/music_paleyer_wg.dart';
import '../../../../core/route/rout_generator.dart';
import '../../domain/entities/music.dart';
import '../bloc/category_event.dart';

class SongPage extends StatefulWidget {
  final Music music;

  const SongPage({super.key, required this.music});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RecentTrackBloc>().add(
      AddRecentTrackEvent(
        recentTracks: RecentTrackModel(
          userId: widget.music.userId,
          musicId: widget.music.id!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            AppRoute.close();
          },
        ),
        title: Text(
          'FROM “PLAYLISTS”',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.music.imageUrl,
                width: double.infinity,
                height: appH(300),
                fit: BoxFit.cover,
              ),
              MusicPlayerUI(music: widget.music),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
