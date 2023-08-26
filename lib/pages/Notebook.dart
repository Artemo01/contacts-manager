import 'dart:convert';

import 'package:flutter/material.dart';

import '../LocalStorage.dart';
import '../consts.dart';
import '../dto/Note.dart';
import '../widgets/NoteDetailPage.dart';

class Notebook extends StatefulWidget {
  const Notebook({Key? key}) : super(key: key);

  @override
  _NotebookState createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  LocalStorage store = LocalStorage();
  List<Note> notes = [];
  bool isEditMode = false;

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  void getNotes() {
    store.getStringList(NOTES).then((value) {
      List<Note> initialNotes = [];
      value.forEach((element) {
        Map<String, dynamic> eventJson = jsonDecode(element);
        Note initialEvent = Note.fromJson(eventJson);
        initialNotes.add(initialEvent);
      });
      setState(() {
        notes = initialNotes;
      });
    });
  }

  void convertNotesToStrings() {
    List<String> stingNotes = [];
    notes.forEach((element) {
      stingNotes.add(jsonEncode(element));
    });
    store.saveStringList(NOTES, stingNotes);
  }

  void _navigateToNoteDetail(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              NoteDetailPage(note: index >= 0 ? notes[index] : null)),
    );

    if (result != null) {
      setState(() {
        if (index >= 0) {
          notes[index] = result;
        } else {
          notes.add(result);
        }
      });
      convertNotesToStrings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(notes[index].title),
              onTap: isEditMode
                  ? () {
                      setState(() {
                        notes[index].isSelected = !notes[index].isSelected;
                      });
                    }
                  : () {
                      _navigateToNoteDetail(index);
                    },
              onLongPress: () {
                if (!isEditMode) {
                  setState(() {
                    isEditMode = true;
                    notes[index].isSelected = true;
                  });
                }
              },
              trailing: isEditMode
                  ? Checkbox(
                      value: notes[index].isSelected,
                      onChanged: (value) {
                        setState(() {
                          notes[index].isSelected = value ?? false;
                        });
                      },
                    )
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: !isEditMode
          ? FloatingActionButton(
              onPressed: () {
                _navigateToNoteDetail(-1);
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: isEditMode
          ? BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        notes.removeWhere((note) => note.isSelected);
                      });
                    },
                    child: const Icon(Icons.delete),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        for (final note in notes) {
                          note.isSelected = false;
                        }
                      });
                    },
                    child: const Icon(Icons.deselect),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditMode = false;
                      });
                    },
                    child: const Icon(Icons.keyboard_return_sharp),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
