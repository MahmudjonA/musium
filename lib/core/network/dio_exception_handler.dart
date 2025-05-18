import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/logger.dart';

class DioExceptionHandler {
  static Exception handle(DioException dioError) {
    if (dioError.type == DioExceptionType.connectionError ||
        (dioError.type == DioExceptionType.unknown &&
            dioError.error is SocketException)) {
      LoggerService.error('No internet connection');
      return Exception('No internet connection');
    }

    final statusCode = dioError.response?.statusCode;
    final data = dioError.response?.data;

    String? readableMessage;
    if (data is Map<String, dynamic>) {
      readableMessage = data.values.first.toString();
    } else if (data is String) {
      readableMessage = data;
    }

    switch (statusCode) {
      case 400:
        LoggerService.warning('Bad request: $readableMessage');
        return Exception(readableMessage ?? 'Invalid email or password');
      case 401:
        LoggerService.warning('Unauthorized');
        return Exception('Unauthorized: please check your credentials');
      case 403:
        LoggerService.warning('Forbidden');
        return Exception('Access denied');
      case 404:
        LoggerService.warning('Not found');
        return Exception('Requested resource not found');
      case 409:
        LoggerService.warning('Conflict (duplicate): $readableMessage');
        return Exception(readableMessage ?? 'This item already exists');
      case 500:
        LoggerService.warning('Internal server error');
        return Exception('Server error. Please try again later');
      default:
        LoggerService.error('Dio error: ${dioError.message}');
        return Exception(
          readableMessage ?? 'Something went wrong: ${dioError.message}',
        );
    }
  }
}
