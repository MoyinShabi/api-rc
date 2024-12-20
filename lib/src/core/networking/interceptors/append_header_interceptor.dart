import 'package:dio/dio.dart';

class AppendHeaderInterceptor extends Interceptor {
  AppendHeaderInterceptor(
    this._accessKey,
  );

  final String _accessKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final appendHeader = options.extra['append-header'] ?? false;

    if (appendHeader) {
      options.headers['Authorization'] = 'Client-ID $_accessKey';
    }

    options.extra.remove('append-header');

    super.onRequest(options, handler);
  }
}
