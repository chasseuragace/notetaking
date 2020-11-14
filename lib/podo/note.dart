import 'package:notetaking/extenstions.dart';
class Note {
  bool deleted;
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

  toMap() {

    Map<String, dynamic> noteMap = {};
    noteMap['title'] = (this.title=="" ?"untitled":this.title).toSentenceCase();
    noteMap['description'] = this.description;
    noteMap['color'] = this.color;
    noteMap['ofUser'] = this.ofUser;
    noteMap['createdAt'] = this.createdAt;
    noteMap['deleted'] = false;
    return noteMap;
  }

  Note.fromFirebaseDoc(Map<String, dynamic> doc,id) {
    print(doc);
    this.title = doc['title'];
    this.description = doc['description'];
    this.color = doc['color'];
    this.id = id;
    this.ofUser = doc['ofUser'];
    this.createdAt = DateTime.parse(doc['createdAt'].toDate().toString());
    this.deleted =doc["deleted"]??false;
  }
}
