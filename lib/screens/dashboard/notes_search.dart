
import 'package:flutter/material.dart';
import 'package:notetaking/podo/note.dart';

import 'package:notetaking/services/locator.dart';

import '../../constant.dart';
import '../../simple_utils.dart';
import 'grid.dart';
import 'notes_manager.dart';

class NoteSearchDelegate extends SearchDelegate<Note> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return StreamBuilder<List<Note>>(
      initialData: locator.get<NotesManager>().currentNotes,
      stream: locator.get<NotesManager>().notesStream,
      builder: (context, AsyncSnapshot<List<Note>> snap,){
        return searchGrid(notes: snap.data);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder<List<Note>>(
      initialData: locator.get<NotesManager>().currentNotes,
      stream: locator.get<NotesManager>().notesStream,
      builder: (context, AsyncSnapshot<List<Note>> snap,){
        return searchGrid(limit: 4,notes: snap.data);
      },
    );
  }

  Widget searchGrid({int limit ,List<Note> notes}) {
    var filtered = [];
    if (query.isEmpty) {
      filtered = notes.take(3).toList();
    }
    else if (limit == null)
      filtered = notes
          .where((element) => element.title.toLowerCase().contains(query))
          .toList();
    else
      filtered = notes
          .where((element) => element.title.toLowerCase().contains(query))
          .take(limit)
          .toList();
    if (filtered.isEmpty) {
      return ImageAlert(
          image: "empty.png", message: Constants.searchEmptyState);
    }
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Grid(
          notes: filtered,
        ),
      ),
    );
  }
}
