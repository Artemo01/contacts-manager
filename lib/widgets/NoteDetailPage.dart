import 'package:flutter/material.dart';

import '../dto/Note.dart';

class NoteDetailPage extends StatelessWidget {
  final Note? note;

  const NoteDetailPage({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(note != null ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final newNote = Note(
                title: titleController.text,
                content: contentController.text,
              );
              Navigator.pop(context, newNote);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
