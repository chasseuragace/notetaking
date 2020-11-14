
import 'package:get_it/get_it.dart';
import 'package:notetaking/screens/dashboard/notes_manager.dart';
import 'package:notetaking/screens/login/login_manager.dart';

import 'firebase_auth/firebase_auth.dart';
import 'firebase_store/firebase_db.dart';

final GetIt locator =GetIt.instance;

void setup(){
  locator.registerLazySingleton<FireBaseAuthService>(() => FireBaseAuthService());
  locator.registerLazySingleton<FireStoreService>(() => FireStoreService());
  locator.registerLazySingleton<LoginManger>(() => LoginManger());
  locator.registerLazySingleton<NotesManager>(() => NotesManager());
}
