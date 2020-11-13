import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/locator.dart';

class FireStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('NoteUsers');
  CollectionReference notes =
      FirebaseFirestore.instance.collection('NoteNotes');

  Stream<List<Note>> watchNotesOfLoggedInUser() {
    String _userid =
        locator.get<FireBaseAuthService>().getLoggedInUser ?? "test";
    return notes /*.where("ofUser", isEqualTo: _userid)*/ .snapshots()
        .map((element) {
      return element.docs.map((e) {
        return Note.fromFirebaseDoc(e.data());
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
    notes
        .doc(data.id)
        .update(
          data.toMap(),
        )
        .then((value) => print("Note updated"));
  }

  deleteNote(String id) {
    notes.doc(id).delete().then((value) => print("Note deleted"));
  }
}

class Note {
  String title, description, color;
  String ofUser;
  DateTime createdAt;
  String id;

  Note(
    this.title,
    this.description,
    this.color,

  ){this.createdAt=DateTime.now();}

  toMap() {
    Map<String, dynamic> noteMap = {};
    noteMap['title'] = this.title;
    noteMap['description'] = this.description;
    noteMap['color'] = this.color;
    noteMap['ofUser'] = this.ofUser;
    noteMap['createdAt'] = this.createdAt;
    return noteMap;
  }

  Note.fromFirebaseDoc(Map<String, dynamic> doc) {

   print((doc['createdAt']));
    this.title = doc['title'];
    this.description = doc['description'];
    this.color = doc['color'];
    this.id = doc['id'];
    this.ofUser = doc['ofUser'];
    this.createdAt = DateTime.parse(doc['createdAt'].toDate().toString());

  }
}
