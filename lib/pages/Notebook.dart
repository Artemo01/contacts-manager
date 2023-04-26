import 'package:contacts_management/consts.dart';
import 'package:contacts_management/widgets/NewNotePage.dart';
import 'package:flutter/material.dart';

import '../LocalStorage.dart';

class Notebook extends StatefulWidget {
  const Notebook({Key? key}) : super(key: key);

  @override
  _NotebookState createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  LocalStorage store = LocalStorage();
  List<String> notebookList = [];

  @override
  void initState() {
    super.initState();

    store
        .getStringList(NOTES)
        .then((value) => setState(() => notebookList = value));
  }

  void createNewNote(String text) {
    List<String> newNotebookList = notebookList;
    newNotebookList.insert(0, text);
    setState(() {
      notebookList = newNotebookList;
    });
    store.saveStringList(NOTES, notebookList);
  }

  void updateNote(String text, int index) {
    List<String> newNotebookList = notebookList;
    newNotebookList[index] = text;
    setState(() {
      notebookList = newNotebookList;
    });
    store.saveStringList(NOTES, notebookList);
  }

  void openNotePage(
    String title,
    Function noteFunction,
    String initialText,
    int index,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewNotePage(
          title: title,
          saveNote: noteFunction,
          initialText: initialText,
          index: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: notebookList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(
                  notebookList[index],
                  maxLines: 1,
                ),
                onTap: () => openNotePage(
                  notebookList[index],
                  updateNote,
                  notebookList[index],
                  index,
                ),
              ),
            );
          }),
      // body: ListView(
      //   children: notebookList
      //       .map(
      //         (title) => Card(
      //           child: ListTile(
      //             title: Text(
      //               title,
      //               maxLines: 1,
      //             ),
      //             onTap: () => openNotePage(title, updateNote, title),
      //           ),
      //         ),
      //       )
      //       .toList(),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNotePage("New note", createNewNote, "", 0),
        child: const Icon(Icons.add),
      ),
    );
  }
}
