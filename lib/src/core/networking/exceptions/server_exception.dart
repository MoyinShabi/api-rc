import 'package:unsplash_app/src/core/networking/exceptions/exceptions.dart';

final class ServerException extends AppException {
  final String message;
  final String error;

  const ServerException({required this.message, required this.error});

  factory ServerException.fromJson(Map<String, dynamic> json) =>
      ServerException(
        message: json['message'] as String? ?? '',
        error: json['error'] as String? ?? '',
      );

  @override
  String toString() => message;
}
