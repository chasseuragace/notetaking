import 'package:flutter/material.dart';

class Constants {
  static TextStyle title =const TextStyle(
      inherit: false,
      color: Color(0x8a000000),
      fontFamily: "Roboto",
      fontSize: 28.0,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.none);

 static TextStyle content = const TextStyle(
    inherit: false,
    color: Color(0xdd000000),
    fontFamily: "Roboto",
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

 static String  defaultloginError =  'Woopsie! Login Failed, please retry in a minute or so.';
 static String  abortedLoginError =  'Login aborted.';
 static String  exceptionLoginError =  ' 🤷 Something went wrong, please retry in a minute or so.‍';
 static String  appName =  'Clean Notes‍';
 static String  dashBoardTitle =  'My Notes‍';
 static String  alertLogoutMessage =  'Are you sure you want to logout?‍';
 static String  alertLogoutTitle =  'Confirm logout‍';
 static String  alertDeleteMessage =  'Are you sure you want delete this note?‍';
 static String  alertDeleteTitle =  'Delete this note?‍';
 static String  searchEmptyState =  'Empty‍';
}