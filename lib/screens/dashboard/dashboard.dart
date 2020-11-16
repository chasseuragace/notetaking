
import 'package:flutter/material.dart';
import 'package:notetaking/simple_utils.dart';
import 'package:notetaking/constant.dart';
import 'package:notetaking/podo/note.dart';
import 'package:notetaking/screens/edit/edit_note.dart';
import 'package:notetaking/screens/login/login_manager.dart';



import 'package:notetaking/services/locator.dart';
import 'grid.dart';
import 'notes_manager.dart';
import 'notes_search.dart';

class DashBoard extends StatelessWidget {
   final  notesManager =locator
    .get<NotesManager>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme:const IconThemeData(
          color: Colors.black54,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Constants.dashBoardTitle,
            style: Constants.title
                .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ),
        actions:  [
          IconButton(
            icon:const Icon(Icons.search),
            onPressed: () {
                showSearch<Note>(
                    delegate: NoteSearchDelegate(),
                    context: context);
            },
          ),
           IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async{
           var result = await showSimpleAlert(context,
                  message: Constants.alertLogoutMessage,
                  title: Constants.alertLogoutTitle,
                  withImage: true);
              if (result ?? false) locator.get<LoginManger>().logout();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "edit",
        child: Icon(Icons.add),
        onPressed: () async {
          var res = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return EditText(
              isNewNote: true,
            );
          }));
          if (res.runtimeType == Note)
            notesManager.addNewNote(res);
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: StreamBuilder<List<Note>>(
                  initialData: null,
                  stream: locator.get<NotesManager>().watchNotes(),

                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child:
                      !snapshot.hasData ? Center(
                          child: CircularProgressIndicator()) :
                      snapshot.data.isEmpty
                          ? ImageAlert(
                        small: true,
                        image: "add.png",
                        message: Constants.dashboardEmptyState,
                      )
                          : Grid(notes: snapshot.data),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

}






