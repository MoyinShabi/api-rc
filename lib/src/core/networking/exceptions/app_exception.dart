import 'package:dio/dio.dart';
import 'package:unsplash_app/src/core/networking/exceptions/exceptions.dart';

base class AppException implements Exception {
  const AppException();

  factory AppException.fromErrorResponse(Response<dynamic> error) {
    try {
      if (error.statusCode! >= 400 && error.statusCode! < 500) {
        return ServerException.fromJson(error.data as Map<String, dynamic>);
      }

      if (error.statusCode! >= 500) {
        return const ClientException(
          message:
              'We encountered a problem reaching the server. Please try again',
        );
      }

      return const ClientException(message: 'An error occurred.');
    } catch (_) {
      return const ClientException(
          message: 'An error occurred. Please try again');
    }
  }
}
