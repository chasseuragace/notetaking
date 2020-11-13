import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/locator.dart';



class FireStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('NoteUsers');
  CollectionReference notes = FirebaseFirestore.instance.collection('NoteNotes');




  addNewNote(Note data) {
    data.ofUser = locator.get<FireBaseAuthService>().getLoggedInUser??"test";
    notes.doc().set(
      data.toMap(),
    ).then((value) => print("New Note Added"));
  }

  updateNote(Note data){
    notes.doc(data.id).update(
      data.toMap(),
    ).then((value) => print("Note updated"));
  }

  deleteNote(String id){
    notes.doc(id).delete().then((value) => print("Note deleted"));
  }

}
class Note{
  String title,description,color;
  String ofUser;

  String id;

  Note(this.title, this.description, this.color,);

  toMap(){
    Map<String,dynamic> noteMap={};
    noteMap['title']=this.title;
    noteMap['description']=this.title;
    noteMap['color']=this.title;
    noteMap['ofUser']=this.ofUser;
    return noteMap;
  }

  Note.fromFirebaseDoc(this.id);


}