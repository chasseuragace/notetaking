import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/locator.dart';
import 'package:notetaking/extenstions.dart';
class FireStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('NoteUsers');
  CollectionReference notes =
      FirebaseFirestore.instance.collection('NoteNotes');

  Stream<List<Note>> watchNotesOfLoggedInUser() {
    String _userid =
        locator.get<FireBaseAuthService>().getLoggedInUser ?? "test";
    return notes /*.where("ofUser", isEqualTo: _userid)*/ .orderBy("createdAt").snapshots()
        .map((element) {
      return element.docs.map((e) {
        return Note.fromFirebaseDoc(e.data(),e.id);
      }).toList();
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
}

class Note {
  String title, description, color;
  String ofUser;
  DateTime createdAt;
  String id;
copyForUpdate({String id, createdAt}){
  this.id=id;
  this.createdAt=createdAt;


}
  Note(
    this.title,
    this.description,
    this.color,

  ){this.createdAt=DateTime.now();}
  Note.dummy(
      this.title,
      this.description,
      this.color,

      );
  toMap() {
    Map<String, dynamic> noteMap = {};
    noteMap['title'] = this.title.toSentenceCase()+UniqueKey().toString();
    noteMap['description'] = this.description;
    noteMap['color'] = this.color;
    noteMap['ofUser'] = this.ofUser;
    noteMap['createdAt'] = this.createdAt;
    return noteMap;
  }

  Note.fromFirebaseDoc(Map<String, dynamic> doc,id) {
    this.title = doc['title'];
    this.description = doc['description'];
    this.color = doc['color'];
    this.id = id;
    this.ofUser = doc['ofUser'];
    this.createdAt = DateTime.parse(doc['createdAt'].toDate().toString());

  }
}
