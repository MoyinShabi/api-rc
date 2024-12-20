import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:unsplash_app/src/core/utils/result.dart';
import 'package:unsplash_app/src/features/home/data/datasources/unsplash_api_data_source.dart';
import 'package:unsplash_app/src/features/home/domain/models/photo.dart';

part 'photos_repository.g.dart';

class PhotosRepository {
  const PhotosRepository(this._api);

  final UnsplashApiDataSource _api;

  Future<Result<List<Photo>, Exception>> fetchPhotos() async {
    final result =
        await Result.fromAsync(() => _api.getPhotos(numberOfPhotos: 12));
    // throw Exception('Error fetching photos'); // Uncomment this line to test error handling in the UI or turn off the internet connection
    return result;
  }
}

@riverpod
PhotosRepository photosRepository(Ref ref) {
  final apiDataSource = ref.watch(unsplashApiDataSourceProvider);
  return PhotosRepository(apiDataSource);
}
