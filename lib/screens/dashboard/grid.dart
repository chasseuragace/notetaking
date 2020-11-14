import 'package:notetaking/extenstions.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notetaking/podo/note.dart';
import 'package:notetaking/screens/dashboard/notes_manager.dart';
import 'file:///D:/noteapp/notetaking/lib/constant.dart';

import 'package:notetaking/services/locator.dart';
import 'package:notetaking/simple_utils.dart';


import '../edit/edit_note.dart';

class Grid extends StatelessWidget {
  final List<Note> notes;
  Grid({Key key, this.notes}) : super(key: key);
 final noteManager =locator.get<NotesManager>();
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        var note = notes[index];
        return _buildNoteContentPreview(note);
      },
      staggeredTileBuilder: (int index) =>  StaggeredTile.fit(2),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }

  Widget _buildNoteContentPreview(Note note) {

    return OpenContainer(
      onClosed: (result) {
        if (result.runtimeType == Note) {
          Note res = result;
          noteManager.update(res, note);
                }
        else if(result.runtimeType==bool && result)
          noteManager.flagDelete(note);
      },
      closedElevation: 0,
      openBuilder: (BuildContext context,
          void Function({Object returnValue}) action) {
        return EditText(
          noteTitle: note.title, noteDescription: note.description,noteColor: note.color,);
      },
      closedBuilder: (BuildContext context, void Function() action) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 100,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Material(
                borderRadius: BorderRadius.circular(12),
                color: Color(int.tryParse(note.color)).withOpacity(.65) ,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "${note.title}".toSentenceCase(),
                              style: Constants.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "${note.description}",
                        style: Constants.content,
                        textAlign: TextAlign.justify,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                )),
          ),
        );
      },

    );
  }




}
