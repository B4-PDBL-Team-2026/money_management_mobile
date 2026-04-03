import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() => getIt.init();
