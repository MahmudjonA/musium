import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musium/core/common/colors/app_colors.dart';
import 'package:musium/core/responsiveness/app_responsive.dart';
import 'package:musium/core/route/rout_generator.dart';
import 'package:musium/core/utils/logger.dart';
import 'package:musium/features/home/domain/entities/category.dart';
import 'package:musium/features/home/presentation/bloc/get_tracks/get_tracks_bloc.dart';
import 'package:musium/features/home/presentation/pages/song_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../bloc/category_event.dart';
import '../bloc/get_tracks/get_tracks_state.dart';
import '../bloc/music/music_bloc.dart';
import '../bloc/music/music_state.dart';
import '../widgets/music_wg.dart';

class PlaylistPage extends StatefulWidget {
  final Category category;

  const PlaylistPage({super.key, required this.category});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  File? _pickedFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoggerService.info('Category ID: ${widget.category.id}');
    context.read<GetTracksBloc>().add(
      GetTracksEvent(playlistId: widget.category.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () {
              AppRoute.close();
            },
          ),
          title: const Text(
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
              icon: const Icon(Icons.add, color: AppColors.white),
              onPressed: () {
                _showAddMusicBottomSheet(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: appH(20),
            left: appW(20),
            right: appW(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: appH(20),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.network(
                    widget.category.image,
                    width: 260,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  widget.category.title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BlocBuilder<GetTracksBloc, GetMusicState>(
                  builder: (context, state) {
                    if (state is GetMusicLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is GetMusicSuccess) {
                      final tracks = state.tracks;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: appH(10)),
                            child: MusicWg(
                              onTap: () {
                                AppRoute.go(SongPage(music: track));
                              },
                              image: track.imageUrl,
                              title: track.trackName,
                              subTitle: track.trackArtist,
                            ),
                          );
                        },
                      );
                    } else if (state is GetMusicError) {
                      return Center(
                        child: Text(
                          'Ошибка: ${state.message}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddMusicBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocConsumer<AddMusicBloc, MusicState>(
          listener: (context, state) {
            if (state is MusicSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Music added successfully')),
              );
              AppRoute.close();
              context.read<GetTracksBloc>().add(
                GetTracksEvent(playlistId: widget.category.id),
              );
              setState(() {
                _pickedFile = null;
              });
            } else if (state is MusicError) {
              AppRoute.close();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
              setState(() {
                _pickedFile = null;
              });
            }
          },
          builder: (context, state) {
            if (state is MusicLoading) {
              return const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                left: appW(20),
                right: appW(20),
                top: appH(20),
                bottom: MediaQuery.of(context).viewInsets.bottom + appH(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: appH(20)),
                  Row(
                    children: [
                      Text(
                        'Add to playlist',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add, color: AppColors.white),
                        onPressed: () {
                          _pickFileAndAddTrack(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _pickFileAndAddTrack(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      _pickedFile = File(result.files.single.path!);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not authenticated')),
        );
        return;
      }
      context.read<AddMusicBloc>().add(
        AddMusicToStorageEvent(widget.category.id, filePath: _pickedFile!),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No file selected')));
    }
  }
}
