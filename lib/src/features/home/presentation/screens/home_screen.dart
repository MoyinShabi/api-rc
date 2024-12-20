import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unsplash_app/src/features/home/domain/models/photo.dart';
import 'package:unsplash_app/src/features/home/domain/models/user.dart';
import 'package:unsplash_app/src/features/home/presentation/controllers/home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(fetchPhotosProvider);
    final users = ref.watch(fetchUsersProvider);
    final isAddingUser = ref.watch(
        homeControllerProvider.select((value) => value?.isLoading == true));
    return RefreshIndicator.adaptive(
      onRefresh: () {
        return Future.wait([
          ref.refresh(fetchPhotosProvider.future),
          ref.refresh(fetchUsersProvider.future),
        ]);
      },
      child: Column(
        spacing: 8,
        children: [
          Expanded(
            child: photos.when(
              data: (data) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _PhotoList(photos: data)),
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () =>
                  Center(child: const CircularProgressIndicator.adaptive()),
            ),
          ),
          Expanded(
            child: users.when(
              data: (data) => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _UserList(users: data),
              ),
              error: (error, stackTrace) =>
                  Center(child: Text(error.toString())),
              loading: () =>
                  Center(child: const CircularProgressIndicator.adaptive()),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () async {
              await ref.read(homeControllerProvider.notifier).addUser();
              ref.invalidate(fetchUsersProvider);
            },
            child: isAddingUser
                ? SizedBox(
                    height: 12,
                    width: 12,
                    child: const CircularProgressIndicator.adaptive())
                : const Text('Add User'),
          ),
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (_, index) {
        var item = users[index];
        return ListTile(
          title: Text('${item.id} ${item.fullName}'),
          subtitle: Text(item.email),
        );
      },
    );
  }
}

class _PhotoList extends StatelessWidget {
  const _PhotoList({required this.photos});

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: photos.length,
        itemBuilder: (_, index) => _PhotoItem(photo: photos[index]),
      );
}

class _PhotoItem extends StatelessWidget {
  const _PhotoItem({required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image.network(photo.urls!.small),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(photo.likes.toString()),
            ),
          ],
        ),
      );
}
