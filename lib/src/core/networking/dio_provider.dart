import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:unsplash_app/src/core/networking/interceptors/append_header_interceptor.dart';
import 'package:unsplash_app/src/core/utils/env.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final talker = ref.watch(talkerLoggerProvider);
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
    ),
  )..interceptors.addAll(
      [
        AppendHeaderInterceptor(Env.accessKey),
        TalkerDioLogger(
          talker: talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
          ),
        ),
      ],
    );
  return dio;
}

@Riverpod(keepAlive: true)
Talker talkerLogger(Ref ref) {
  return Talker();
}
