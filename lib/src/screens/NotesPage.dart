import 'package:flutter/material.dart';
import 'package:meditation_app/src/screens/sideBar.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../services/NoteDatabase.dart';
import '../utils/NoteFiles.dart';
import 'addEditNote.dart';

import 'note_detail_page.dart';
import '../widgets/NoteCardWidget.dart';
import 'package:meditation_app/src/screens/voice_input.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

 @override
  void dispose() {
   NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: sideBar(),
    appBar: AppBar(
      backgroundColor:
      Color(0xFFE1D7CE),
      elevation: 0.0,
      centerTitle: true,
      title: Text("Journal",
        style: TextStyle(
          color: Color(0xFF896C64),
          fontSize: 40,
        ),),
    ),
    body: Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/journal2.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: isLoading
          //  ? //CircularProgressIndicator()
            //: notes.isEmpty
            ? Text(
          'No Notes',
          style: TextStyle(color: Colors.white, fontSize: 24),
        )
            : buildNotes(),
      ),
    ),
    floatingActionButton: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: "btn3",
            backgroundColor: Colors.white,
            child: Icon(Icons.edit_outlined,color: Color(0xFF896C64),),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditNotePage()),
              );

              refreshNotes();
            },
          ),
        ),
        SizedBox(height: 10,),
        FloatingActionButton(
          heroTag: "btn2",
          backgroundColor: Color(0xFF896C64),
          child: Icon(Icons.mic),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VoiceInput()),
            );

            refreshNotes();
          },
        ),
      ],
    ),
  );

  Widget buildNotes() => ListView.builder(
    padding: EdgeInsets.all(8),
    itemCount: notes.length,
    //staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    //crossAxisCount: 4,
    //mainAxisSpacing: 4,
    // crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final note = notes[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteDetailPage(noteId: note.id!),
          ));

          refreshNotes();
        },
        child: NoteCardWidget(note: note, index: index),
      );
    },
  );
}