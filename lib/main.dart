import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notetaking/services/constant.dart';
import 'package:notetaking/services/firebase_auth/firebase_auth.dart';
import 'package:notetaking/services/firebase_store/firebase_db.dart';
import 'package:notetaking/services/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes Taker ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
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
                                Note("title", "description", "color"));
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

class Grid extends StatelessWidget {
  final List<Note> notes;

  const Grid({Key key, this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) {
        var note = notes[index];
        return _buildNoteContentPreview(note);
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }

  ConstrainedBox _buildNoteContentPreview(Note note) {

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: new Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.red.withOpacity(.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${note.title}",
                          style: Constants.title,overflow: TextOverflow.ellipsis,maxLines: 2,
                        ),
                      ),
                      IconButton(icon: Icon(Icons.delete), onPressed: () {  },)
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "${note.description + "aslkdj lkajsd aklsj akls jklas jklas a"
                        "sjk jkasjkdsa jkjsak jkals jklsajksal jksalkjsal kjalsajkslajkl kjalkjs ljksa kja"
                        "sjk jkasjkdsa jkjsak jkals jklsajksal jksalkjsal kjalsajkslajkl kjalkjs ljksa kja"
                        "sjk jkasjkdsa jkjsak jkals jklsajksal jksalkjsal kjalsajkslajkl kjalkjs ljksa kja"
                        "sjk jkasjkdsa jkjsak jkals jklsajksal jksalkjsal kjalsajkslajkl kjalkjs ljksa kja"}",
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
  }
}
