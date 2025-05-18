import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/common/colors/app_colors.dart';
import '../../../../core/responsiveness/app_responsive.dart';
import '../../../../core/route/rout_generator.dart';
import '../../../home/domain/entities/category.dart';
import '../../../home/presentation/bloc/category/category_bloc.dart';
import '../../../home/presentation/bloc/category/category_state.dart';
import '../../../home/presentation/bloc/category_event.dart';
import '../../../home/presentation/bloc/get_tracks/get_tracks_bloc.dart';
import '../../../home/presentation/bloc/music/music_bloc.dart';
import '../../../home/presentation/bloc/music/music_state.dart';
import '../../../home/presentation/bloc/recent_tracks/recent_tracks_bloc.dart';
import '../../../home/presentation/bloc/recent_tracks/recent_tracks_state.dart';
import '../../../home/presentation/pages/song_page.dart';
import '../widgets/album_wg.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  File? _pickedFile;
  int selectedIndex = -1;

  List<Category> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<GetCategoriesBloc>().add(GetCategoriesEvent());
    context.read<RecentTrackBloc>().add(GetRecentTracksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCategoriesBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccess) {
          categories = state.categories;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Row(
              children: [
                Image.asset('assets/images/logo.jpg', width: 50, height: 50),
                SizedBox(width: appW(15)),
                Text(
                  'Your Library',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: appH(27),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(
              top: appH(20),
              left: appW(20),
              right: appW(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: appW(56),
                      height: appH(60),
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _showAddMusicBottomSheet(context);
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ),
                    SizedBox(width: appW(10)),
                    Text(
                      'Add New Playlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: appH(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appH(10)),
                Row(
                  children: [
                    Container(
                      width: appW(56),
                      height: appH(60),
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(child: Icon(Icons.favorite_border)),
                    ),
                    SizedBox(width: appW(10)),
                    Text(
                      'Your Liked Songs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: appH(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appH(20)),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        Icons.compare_arrows,
                        color: AppColors.grey,
                        size: appH(30),
                      ),
                      SizedBox(width: appW(10)),
                      Text(
                        'Recently played',
                        style: TextStyle(
                          color: AppColors.neonGreen,
                          fontSize: appH(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: appH(15)),
                Expanded(
                  child: BlocBuilder<RecentTrackBloc, RecentTrackState>(
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
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: tracks.length,
                          itemBuilder: (context, index) {
                            final track = tracks[index];
                            return GestureDetector(
                              onTap: () {
                                AppRoute.go(SongPage(music: track.music!));
                              },
                              child: AlbumWg(
                                image: track.music!.imageUrl,
                                title: track.music!.trackName,
                                subtitle: track.music!.trackArtist,
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                GetTracksEvent(playlistId: selectedCategoryId ?? 0),
              );
              setState(() {
                _pickedFile = null;
                selectedCategoryId = null;
              });
            } else if (state is MusicError) {
              AppRoute.close();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
              setState(() {
                _pickedFile = null;
                selectedCategoryId = null;
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
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    dropdownColor: AppColors.background,
                    decoration: InputDecoration(
                      labelText: 'Select Playlist',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.neonGreen),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.neonGreen),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: appH(16)),
                    items:
                        categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.title),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                    hint: Text(
                      'Select Playlist',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: appH(20)),
                  Row(
                    children: [
                      Text(
                        'Add music file',
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
    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a playlist first')),
      );
      return;
    }

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
        AddMusicToStorageEvent(selectedCategoryId!, filePath: _pickedFile!),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No file selected')));
    }
  }
}
