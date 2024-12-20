import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unsplash_app/src/core/utils/env.dart';
import 'package:unsplash_app/src/core/networking/dio_provider.dart';
import 'package:unsplash_app/src/features/home/domain/models/user.dart';

part 'mockapi_data_source.g.dart';

@RestApi()
abstract class MockapiDataSource {
  factory MockapiDataSource(Dio dio, {String? baseUrl}) = _MockapiDataSource;

  @GET('/user')
  Future<List<User>> getUsers();

  @POST('/user')
  Future<User> addUser({@Body() required User payload});
}

@riverpod
MockapiDataSource mockapiDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return MockapiDataSource(dio, baseUrl: Env.mockapiBaseUrl);
}
