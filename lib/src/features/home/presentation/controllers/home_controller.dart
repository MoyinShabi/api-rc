import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unsplash_app/src/features/home/data/repositories/photos_repository.dart';
import 'package:unsplash_app/src/features/home/data/repositories/users_repository.dart';
import 'package:unsplash_app/src/features/home/domain/models/photo.dart';
import 'package:unsplash_app/src/features/home/domain/models/user.dart';

part 'home_controller.g.dart';

@riverpod
Future<List<Photo>> fetchPhotos(Ref ref) async {
  final result = await ref.watch(photosRepositoryProvider).fetchPhotos();
  return result.fold(
    (data) => data,
    (error) => throw error,
  );
}

@riverpod
Future<List<User>> fetchUsers(Ref ref) async {
  final result = await ref.watch(usersRepositoryProvider).getUsers();
  return result.fold(
    (data) => data,
    (error) => throw error,
  );
}

@riverpod
class HomeController extends _$HomeController {
  late final UsersRepository _usersRepository;
  @override
  AsyncValue? build() {
    _usersRepository = ref.watch(usersRepositoryProvider);
    return null;
  }

  Future<void> addUser() async {
    final user = User(
      fullName: "Debby Nolan",
      email: "d.nolan@gmail.com",
      avatar:
          "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/199.jpg",
      school: "University of California, Los Angeles",
      level: 500,
      graduationYear: "2025",
    );

    state = AsyncLoading();
    final result = await _usersRepository.addUser(user: user);
    state = result.fold(
      (data) => AsyncData(data),
      (error) => AsyncError(error, StackTrace.current),
    );
  }
}
