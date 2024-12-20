import 'package:unsplash_app/src/core/networking/exceptions/exceptions.dart';

final class ClientException extends AppException {
  final String message;

  const ClientException({required this.message});

  @override
  String toString() => message;
}
