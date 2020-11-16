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
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  static String defaultloginError =
      'Woopsie! Login Failed, please retry in a minute or so.';
  static String abortedLoginError = 'Login aborted.';
  static String exceptionLoginError =
      " 🤷 Something isn't right, please retry in a minute or so.";
  static String appName = 'Clean Notes‍';
  static String dashBoardTitle = 'My Notes‍';
  static String alertLogoutMessage = 'Are you sure you want to logout?‍';
  static String alertLogoutTitle = 'Confirm logout‍';
  static String alertDeleteMessage = 'Are you sure you want delete this note?‍';
  static String alertDeleteTitle = 'Delete this note?‍';
  static String searchEmptyState = 'Empty‍';
  static String dashboardEmptyState = 'Your collection seems empty\n';
  static var months = {
    "1": "Jan",
    "2": "Feb",
    "3": "March",
    "4": "April",
    "5": "May",
    "6": "June",
    "7": "July",
    "8": "Aug",
    "9": "Sep",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec",
  };
}