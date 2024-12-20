import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unsplash_app/src/core/utils/env.dart';
import 'package:unsplash_app/src/core/networking/dio_provider.dart';
import 'package:unsplash_app/src/features/home/domain/models/photo.dart';

part 'unsplash_api_data_source.g.dart';

@RestApi()
abstract class UnsplashApiDataSource {
  factory UnsplashApiDataSource(Dio dio, {String? baseUrl}) =
      _UnsplashApiDataSource;

  @Extra({'append-header': true})
  @GET('/photos')
  Future<List<Photo>> getPhotos(
      {@Query('per_page') required int numberOfPhotos});
}

@riverpod
UnsplashApiDataSource unsplashApiDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return UnsplashApiDataSource(dio, baseUrl: Env.unsplashBaseUrl);
}
