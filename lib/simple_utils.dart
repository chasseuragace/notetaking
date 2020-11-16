import 'package:flutter/material.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/locator.dart';

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
    child: Text(
      negativeText,
      style: TextStyle(color: Colors.grey),
    ),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    elevation: 0,
    title: Row(
      children: [
        CircleAvatar(
            backgroundImage: NetworkImage(
                "${locator
                    .get<FireBaseAuthService>()
                    .getLoggedInUserDp}")),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        ),
      ],
    ),
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
  return TweenAnimationBuilder(
    duration: const Duration(milliseconds: 400),
    child: child,
    tween: Tween<double>(begin: .8, end: 1),
    builder: (BuildContext context, double value, Widget child) {
      return Transform.scale(
        child: child,
        scale: value,
      );
    },
  );
}

class NoGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child,
      AxisDirection axisDirection) {
    return child;
  }
}

class ImageAlert extends StatelessWidget {
  final String image;
  final String message;
  final bool small;

  const ImageAlert({Key key,
    @required this.image,
    @required this.message,
    this.small = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          Expanded(flex: 2, child: Image.asset("assets/$image")),
          Expanded(
            flex: 2,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: small ? 24 : 30, color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}
