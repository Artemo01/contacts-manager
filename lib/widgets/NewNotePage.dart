import 'package:flutter/material.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage(
      {Key? key,
      required this.title,
      required this.saveNote,
      this.initialText,
      this.index})
      : super(key: key);

  final String title;
  final Function saveNote;
  final String? initialText;
  final int? index;

  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void saveText() {
    String text = _controller.text;
    widget.saveNote(text, widget.index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () => saveText(),
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: TextField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: 30,
      ),
    );
  }
}
