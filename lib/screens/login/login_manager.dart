import 'package:flutter/material.dart';
import 'package:notetaking/screens/dashboard/notes_manager.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/locator.dart';

enum LoginStates { loggedIn, loggedOut, loading, error }

class LoginManger {
  ValueNotifier<LoginStates> _notifier;
  String _errorMessage;

  String get errorText => _errorMessage;

  ValueNotifier<LoginStates> get currentState {
    LoginStates state;
    if (locator.get<FireBaseAuthService>().getLoggedInUser != null)
      state = LoginStates.loggedIn;
    else
      state = LoginStates.loggedOut;
    _notifier = ValueNotifier(state);
    return _notifier;
  }

  login() async {
    _notifier.value = LoginStates.loading;
    var result = await locator.get<FireBaseAuthService>().signInWithGoogle();
    if (result == null) {
      _errorMessage = null;
      _notifier.value = LoginStates.error;
      Future.delayed(Duration(seconds: 3), () {
        _notifier.value = LoginStates.loggedOut;
      });
    } else if (result is String) {
      _errorMessage = result;
      _notifier.value = LoginStates.error;
    } else
      _notifier.value = LoginStates.loggedIn;
  }

  logout() async {
    _notifier.value = LoginStates.loading;
    locator.get<NotesManager>().clean();
    await locator.get<FireBaseAuthService>().signOut();
    _notifier.value = LoginStates.loggedOut;
  }
}