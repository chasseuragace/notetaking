
import 'dart:async';

import 'package:notetaking/podo/note.dart';
import 'package:notetaking/services/firebase_store/firebase_db.dart';
import 'package:notetaking/services/locator.dart';

class NotesManager{

  Stream<List<Note>> watchNotes(){
     locator.get<FireStoreService>().watchNotesOfLoggedInUser(setNotes:(event){_notes=event;},updateList:(){_updateNotesList();});
    return notesStream;
  }
  List<Note> _notes;
  final _controller = StreamController<List<Note>>.broadcast();
  List<Note> get currentNotes => _notes;
  _closeSink() {
    _controller.close();

  }

  _updateNotesList() async {
    _controller.sink.add(_notes);
  }

  Stream<List<Note>> get notesStream =>
      _controller.stream.asBroadcastStream(onListen: (w) {
        w.resume();
      },);

  addNewNote(res) {
    locator.get<FireStoreService>().addNewNote(res);
  }

  void update(Note res, Note note) {
    res.copyForUpdate(id:note.id,createdAt: note.createdAt);
    locator.get<FireStoreService>().updateNote(res);
  }
  void flagDelete(Note note) {
    Future.delayed(Duration(milliseconds: 600),(){
      locator.get<FireStoreService>().flagAsDeleted(note.id);
    });
  }

clean(){
    locator.get<FireStoreService>().notessubs.cancel();
}
}