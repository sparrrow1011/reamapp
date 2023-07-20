import 'package:get_it/get_it.dart';
import '../service/navigationService.dart';
//
// GetIt locator = GetIt.asNewInstance();
//
// void setupLocator() {
//   locator.registerLazySingleton(() => NavigationService());
// }
GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
}
