import 'package:flutter/material.dart';

showSimpleAlert(BuildContext context,
    {String positiveText = "OK",
      String negativeText = "Cancel",
      String title = "",
      String message = "",
      bool dismissible = true}) async {
  Widget okButton = FlatButton(
    child: Text(positiveText),
    onPressed: () {
      Navigator.of(context).pop(true);
    },
  );
  Widget cancelButton = FlatButton(
    child: Text(negativeText,style: TextStyle(color: Colors.grey),),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    elevation: 0,
    title: Text(title),
    content: Text(message),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  // show the dialog
  return showDialog(
    barrierDismissible: dismissible,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget makeScaleTween({Widget child, context}) {
  return TweenAnimationBuilder(duration: const Duration(milliseconds: 400),
    child: child,
    tween: Tween<double>(begin: .8,end: 1),
    builder: (BuildContext context, double value, Widget child) {
    return Transform.scale(
      child: child,
      scale: value,
    );
    },);
}

class NoGlow extends ScrollBehavior{

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}