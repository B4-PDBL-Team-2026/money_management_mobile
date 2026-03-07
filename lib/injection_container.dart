import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  // third party packages
  sl.registerLazySingleton(() => Dio());
}
