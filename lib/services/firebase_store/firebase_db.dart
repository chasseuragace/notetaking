import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:notetaking/podo/note.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/locator.dart';


class FireStoreService {
  // ignore: cancel_subscriptions
  StreamSubscription notessubs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('NoteUsers');
  CollectionReference notes =
      FirebaseFirestore.instance.collection('NoteNotes');

  watchNotesOfLoggedInUser({bool deleted = false, Null Function() updateList, Null Function(dynamic event) setNotes}) {
    String _userid =
        locator.get<FireBaseAuthService>().getLoggedInUser ?? "test";
    notessubs =
     (notes.where("ofUser", isEqualTo: _userid).where(
          "deleted",
          isEqualTo: deleted,
        )).orderBy("createdAt").snapshots().map((element) {
      return element.docs.map((e) {
        return Note.fromFirebaseDoc(e.data(), e.id);
      }).toList();
    }).listen((event) {
      setNotes(event);
      updateList();
     });
  }

  addNewNote(Note data) {
    data.ofUser = locator.get<FireBaseAuthService>().getLoggedInUser ?? "test";
    notes
        .doc()
        .set(
          data.toMap(),
        )
        .then((value) => print("New Note Added"));
  }

  updateNote(Note data) {
    data.ofUser = locator.get<FireBaseAuthService>().getLoggedInUser ?? "test";
    notes
        .doc(data.id)
        .update(
          data.toMap(),
        )
        .then((value) => print("Note updated"));
  }

  deleteNote(String id) {
    print(id);
    notes.doc(id).delete().then((value) => print("Note deleted"));
  }

  flagAsDeleted(String id) {
    notes.doc(id).update({"deleted": true}).then(
        (value) => print("note flagged as deleted"));
  }
}
