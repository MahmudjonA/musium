import 'package:dio/dio.dart';
import 'package:musium/core/network/dio_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/network/dio_exception_handler.dart';
import '../../../../../core/utils/logger.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;

      if (user == null || session == null) {
        throw Exception('User registration is pending email confirmation');
      }
      DioClient().setToken(session.accessToken);
    } on DioException catch (dioError) {
      throw DioExceptionHandler.handle(dioError);
    } catch (e) {
      LoggerService.error('Error during user registration: $e');
      rethrow;
    }
  }

  @override
  Future<void> logInUser({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? session = res.session;
      final User? user = res.user;

      if (user == null || session == null) {
        throw Exception('Error logging in. Please check your credentials.');
      }

      DioClient().setToken(session.accessToken);
    } on DioException catch (dioError) {
      throw DioExceptionHandler.handle(dioError);
    } catch (e) {
      LoggerService.error('Error during user registration: $e');
      rethrow;
    }
  }
}
