
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetaking/screens/dashboard/dashboard.dart';

import 'package:notetaking/services/locator.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes Taker ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashBoard(),
    );
  }
}


