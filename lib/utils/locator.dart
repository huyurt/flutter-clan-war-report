import 'package:get_it/get_it.dart';
import 'package:more_useful_clash_of_clans/utils/helpers/shared_preference_helper.dart';

setupLocator(GetIt locator) {
  locator.registerLazySingleton(() => SharedPreferenceHelper());
}
