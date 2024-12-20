import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:unsplash_app/src/core/utils/result.dart';
import 'package:unsplash_app/src/features/home/data/datasources/mockapi_data_source.dart';
import 'package:unsplash_app/src/features/home/domain/models/user.dart';

part 'users_repository.g.dart';

class UsersRepository {
  const UsersRepository(this._api);

  final MockapiDataSource _api;

  Future<Result<List<User>, Exception>> getUsers() async {
    final result = await Result.fromAsync(() => _api.getUsers());
    // throw Exception('Error fetching photos'); // Uncomment this line to test error handling in the UI or turn off the internet connection
    return result;
  }

  Future<Result<User, Exception>> addUser({required User user}) async {
    final result = await Result.fromAsync(() => _api.addUser(payload: user));
    // throw Exception('Error fetching photos'); // Uncomment this line to test error handling in the UI or turn off the internet connection
    return result;
  }
}

@riverpod
UsersRepository usersRepository(Ref ref) {
  final apiDataSource = ref.watch(mockapiDataSourceProvider);
  return UsersRepository(apiDataSource);
}
