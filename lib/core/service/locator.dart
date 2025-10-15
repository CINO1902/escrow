import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/authDatasource.dart';
import '../../features/auth/data/repositories/auth_repo.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/controller/auth_controller.dart';
import 'dio_service.dart';
import 'http_service.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator
    ..registerLazySingleton<AuthDatasourceImp>(
      () => AuthDatasourceImp(locator()),
    )
    ..registerLazySingleton<AuthDatasource>(() => AuthDatasourceImp(locator()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(locator()))
    ..registerLazySingleton(() => AuthController(locator()))
    //packages
    ..registerLazySingleton<HttpService>(() => DioService(locator()))
    ..registerLazySingleton(() => Dio());
}
