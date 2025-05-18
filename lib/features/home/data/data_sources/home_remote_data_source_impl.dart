import 'dart:io';
import 'package:audio_metadata_reader/audio_metadata_reader.dart'
    as AudioMetadataReader;
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:dio/dio.dart';
import 'package:musium/core/utils/logger.dart';
import 'package:musium/features/home/data/models/category_model.dart';
import 'package:musium/features/home/data/models/genres_model.dart';
import 'package:musium/features/home/data/models/music_model.dart';
import 'package:musium/features/home/data/models/recent_track_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_exception_handler.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient = DioClient();
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<CategoryModel>> getCategories() async {
    LoggerService.info('[getCategories] Fetching categories...');
    try {
      final response = await dioClient.get('/categories');
      LoggerService.info('[getCategories] Response: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        final categories = data.map((e) => CategoryModel.fromJson(e)).toList();
        LoggerService.info('[getCategories] Success: $categories');
        return categories;
      } else {
        LoggerService.warning('[getCategories] Failed: ${response.statusCode}');
        throw Exception('Category fetched failed: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      LoggerService.error('[getCategories] Dio error: $dioError');
      throw DioExceptionHandler.handle(dioError);
    } catch (e) {
      LoggerService.error('[getCategories] Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    LoggerService.info('[getGenres] Fetching genres...');
    try {
      final response = await dioClient.get('/genres');
      LoggerService.info('[getGenres] Response: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        final genres = data.map((e) => GenreModel.fromJson(e)).toList();
        LoggerService.info('[getGenres] Success: $genres');
        return genres;
      } else {
        LoggerService.warning('[getGenres] Failed: ${response.statusCode}');
        throw Exception('Genres fetched failed: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      LoggerService.error('[getGenres] Dio error: $dioError');
      throw DioExceptionHandler.handle(dioError);
    } catch (e) {
      LoggerService.error('[getGenres] Error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> addTrackToStorage(File file) async {
    LoggerService.info('[addTrackToStorage] Uploading file: ${file.path}');
    try {
      final metadata = await _extractAudioMetadata(file);

      final fileName = _sanitizeFilename(file.path.split('/').last);
      final musicUrl = await _uploadAudioFile(file, fileName);
      final imageUrl = await _uploadCoverFromMetadata(metadata);

      LoggerService.info(
        '[addTrackToStorage] Upload complete: $musicUrl, $imageUrl',
      );

      return {
        'musicUrl': musicUrl,
        'imageUrl': imageUrl,
        'trackName': metadata.title ?? 'Unknown Title',
        'trackArtist': metadata.artist ?? 'Unknown Artist',
        'duration': metadata.duration?.inSeconds ?? 0,
      };
    } catch (e) {
      LoggerService.error('[addTrackToStorage] Upload error: $e');
      rethrow;
    }
  }

  String _sanitizeFilename(String filename) {
    LoggerService.info('[sanitizeFilename] Sanitizing filename: $filename');
    final name = filename.split('.').first;
    final extension = filename.split('.').last;
    final sanitized =
        '${name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.$extension';
    LoggerService.info('[sanitizeFilename] Sanitized: $sanitized');
    return sanitized;
  }

  Future<String> _uploadAudioFile(File file, String fileName) async {
    LoggerService.info('[uploadAudio] Uploading: $fileName');
    try {
      const bucket = 'music.mp3';

      if (!file.existsSync()) {
        LoggerService.error('[uploadAudio] File not found: ${file.path}');
        throw Exception('File does not exist at path: ${file.path}');
      }

      await supabase.storage
          .from(bucket)
          .upload(
            fileName,
            file,
            fileOptions: FileOptions(
              contentType: _getContentType(fileName),
              upsert: false,
            ),
          );

      final url = supabase.storage.from(bucket).getPublicUrl(fileName);
      LoggerService.info('[uploadAudio] Uploaded to: $url');
      return url;
    } on StorageException catch (e) {
      if (e.statusCode == 409) {
        LoggerService.warning('[uploadAudio] Duplicate file: $fileName');
        throw Exception('Файл с таким именем уже существует');
      }
      LoggerService.error('[uploadAudio] Storage error: $e');
      rethrow;
    } catch (e) {
      LoggerService.error('[uploadAudio] Unknown error: $e');
      rethrow;
    }
  }

  String _getContentType(String filename) {
    LoggerService.info('[getContentType] Checking: $filename');
    final extension = filename.split('.').last.toLowerCase();
    final type = switch (extension) {
      'mp3' => 'audio/mpeg',
      'm4a' => 'audio/mp4',
      'wav' => 'audio/wav',
      _ => 'audio/mpeg',
    };
    LoggerService.info('[getContentType] Content type: $type');
    return type;
  }

  // ! Extracts audio metadata from the given file and image to the data base.
  Future<AudioMetadata> _extractAudioMetadata(File file) async {
    LoggerService.info('[extractMetadata] Extracting from: ${file.path}');
    try {
      final metadata = await AudioMetadataReader.readMetadata(
        file,
        getImage: true,
      );
      LoggerService.info('[extractMetadata] Extracted: $metadata');
      return metadata;
    } catch (e) {
      LoggerService.error('[extractMetadata] Error: $e');
      rethrow;
    }
  }

  Future<String> _uploadCoverFromMetadata(AudioMetadata metadata) async {
    LoggerService.info('[uploadCover] Uploading cover...');
    try {
      if (metadata.pictures.isEmpty) {
        LoggerService.warning('[uploadCover] No cover found.');
        return '';
      }

      const bucket = 'music.img';
      final imageBytes = metadata.pictures.first.bytes;
      final fileName = 'cover_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage
          .from(bucket)
          .uploadBinary(
            fileName,
            imageBytes,
            fileOptions: FileOptions(contentType: 'image/jpeg', upsert: false),
          );

      final url = supabase.storage.from(bucket).getPublicUrl(fileName);
      LoggerService.info('[uploadCover] Cover uploaded: $url');
      return url;
    } on StorageException catch (e) {
      if (e.statusCode == 409) {
        LoggerService.warning(
          '[uploadCover] Duplicate cover file: already exists',
        );
        throw Exception('Обложка с таким именем уже существует');
      }
      LoggerService.error('[uploadCover] Storage error: $e');
      rethrow;
    } catch (e) {
      LoggerService.error('[uploadCover] Error: $e');
      return '';
    }
  }

  @override
  Future<void> addTrack(MusicModel music) async {
    LoggerService.info('[addTrack] Adding track: ${music.toJson()}');
    try {
      final response = await dioClient.post('/musics', data: music.toJson());

      LoggerService.info('[addTrack] Response: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('[addTrack] Track added successfully');
      } else {
        LoggerService.warning('[addTrack] Failed: ${response.statusCode}');
        throw Exception('Track add failed: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      LoggerService.error('[addTrack] Dio error: $dioError');
      throw DioExceptionHandler.handle(dioError);
    } catch (e) {
      LoggerService.error('[addTrack] Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<MusicModel>> getTracks({int? playlistId}) async {
    LoggerService.info('[getTracks] Fetching tracks...');
    try {
      LoggerService.info('[getTracks] Playlist ID: $playlistId');
      final queryParams =
          playlistId != null ? {'playlist_id': 'eq.$playlistId'} : null;

      LoggerService.info('[getTracks] Query params: $queryParams');
      final response = await dioClient.get('/musics', queryParams: queryParams);

      LoggerService.info('[getTracks] Response: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        final tracks = data.map((e) => MusicModel.fromJson(e)).toList();
        LoggerService.info('[getTracks] Success: $tracks');
        return tracks;
      } else {
        LoggerService.warning('[getTracks] Failed: ${response.statusCode}');
        throw Exception('Tracks fetched failed: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      LoggerService.error('[getTracks] Dio error: $dioError');
      throw DioExceptionHandler.handle(dioError);
    } catch (e) {
      LoggerService.error('[getTracks] Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> addRecentTrack(RecentTrackModel recentTrack) async {
    LoggerService.info(
      '[addRecentTrack] Adding recent track: ${recentTrack.toJson()}',
    );
    try {
      final response = await dioClient.post(
        '/recent_tracks',
        data: recentTrack.toJson(),
      );

      LoggerService.info('[addRecentTrack] Response: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        LoggerService.info('[addRecentTrack] Recent track added successfully');
      } else {
        LoggerService.warning(
          '[addRecentTrack] Failed: ${response.statusCode}',
        );
        throw Exception('Recent track add failed: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      LoggerService.error('[addRecentTrack] Dio error: $dioError');
      throw DioExceptionHandler.handle(dioError);
    } catch (e) {
      LoggerService.error('[addRecentTrack] Error: $e');
      rethrow;
    }
  }

  @override
  Future<List<RecentTrackModel>> getRecentTracks({int? limit}) async {
    LoggerService.info('[getRecentTracks] Fetching recent tracks...');
    try {
      final baseQuery = 'select=*,music:musics(*)&order=created_at.desc';
      final limitQuery = limit != null ? '&limit=$limit' : '';

      final url = '/recent_tracks?$baseQuery$limitQuery';
      LoggerService.info('[getRecentTracks] Request URL: $url');

      final response = await dioClient.get(url);

      LoggerService.info('[getRecentTracks] Response: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        final recentTracks =
        data.map((e) => RecentTrackModel.fromJson(e)).toList();
        LoggerService.info('[getRecentTracks] Success: $recentTracks');
        return recentTracks;
      } else {
        LoggerService.warning(
          '[getRecentTracks] Failed: ${response.statusCode}',
        );
        throw Exception('Recent tracks fetch failed: ${response.statusCode}');
      }
    } on DioException catch (dioError) {
      LoggerService.error('[getRecentTracks] Dio error: $dioError');
      throw DioExceptionHandler.handle(dioError);
    } catch (e) {
      LoggerService.error('[getRecentTracks] Error: $e');
      rethrow;
    }
  }

}
