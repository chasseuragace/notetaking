
import 'package:get_it/get_it.dart';

import 'firebase_auth/firebase_auth.dart';
import 'firebase_store/firebase_db.dart';

final GetIt locator =GetIt.instance;

void setup(){
  locator.registerLazySingleton<FireBaseAuthService>(() => FireBaseAuthService());
  locator.registerLazySingleton<FireStoreService>(() => FireStoreService());
}
