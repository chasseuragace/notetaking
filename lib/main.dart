import 'package:flutter/material.dart';
import 'package:notetaking/services/firebase_store/firebase_db.dart';
import 'package:notetaking/services/locator.dart';

void main() {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (){
          locator.get<FireStoreService>().addNewNote(Note("title", "description", "color"));
        },
        child: Text("add"),

      );
  }
}
