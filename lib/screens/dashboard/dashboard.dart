import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/firebase_store/firebase_db.dart';
import 'package:notetaking/services/locator.dart';


import 'grid.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),),
      child: StreamBuilder<User>(
          stream: locator.get<FireBaseAuthService>().loggedInUser,
          builder: (context, snapshot) {
            return Center(
              child: StreamBuilder<List<Note>>(
                  stream: locator
                      .get<FireStoreService>()
                      .watchNotesOfLoggedInUser(),
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        if (snapshot.hasData)
                          Expanded(
                              flex: 1,
                              child: Grid(
                                notes: snapshot.data,
                              )),
                        FlatButton(
                          onPressed: () {
                            locator.get<FireStoreService>().addNewNote(
                                Note("title", "description", Colors.red.value.toString()));
                          },
                          child: Text("add"),
                        ),
                        FlatButton(
                          onPressed: () {
                            locator
                                .get<FireBaseAuthService>()
                                .signInWithGoogle();
                          },
                          child: Text("login"),
                        ),
                        FlatButton(
                          onPressed: () {
                            locator.get<FireBaseAuthService>().signOut();
                          },
                          child: Text("logout"),
                        ),
                      ],
                    );
                  }),
            );
          }),
    );
  }
}