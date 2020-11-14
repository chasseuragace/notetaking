import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notetaking/simple_utils.dart';
import 'package:notetaking/screens/dashboard/dashboard.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/locator.dart';

import '../../constant.dart';
import 'login_manager.dart';

class LoginWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: locator.get<FireBaseAuthService>().loggedInUser,
        builder: (context, snapshot) {
          return snapshot.hasData ? DashBoard() : LogIn();
        });
  }
}

class LogIn extends StatelessWidget {
  final LoginManger _manager = locator.get<LoginManger>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child:  makeScaleTween(
            context: context,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              elevation: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: MediaQuery.of(context).size.height * .7,
                child: Column(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: Image.asset("assets/edit.png"),
                    ),
                    Text(
                      Constants.appName,
                      style: Constants.title,
                    ),
                    Expanded(
                      flex: 2,
                      child: ValueListenableBuilder<LoginStates>(
                        valueListenable: _manager.currentState,
                        builder: (con, val, _) {
                          if (val == LoginStates.error) showLoginFailMessage(context);
                          return AnimatedSwitcher(
                            child: val == LoginStates.loading
                                ? CircularProgressIndicator()
                                : OutlineButton.icon(
                              onPressed: () async {
                                _manager.login();
                              },
                              label: Text("Login with Google"),
                              icon: Text(
                                "G",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            duration: Duration(milliseconds: 400),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void showLoginFailMessage(context) {
    Future.delayed(Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_manager.errorText ?? Constants.defaultloginError)));
    });
  }
}