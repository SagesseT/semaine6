import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _confirmSave() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.note == null ? "Ajouter" : "Modifier"),
        content: Text(widget.note == null
            ? "Voulez-vous vraiment ajouter cette note ?"
            : "Voulez-vous vraiment modifier cette note ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Non"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _saveNote();
            },
            child: const Text("Oui"),
          ),
        ],
      ),
    );
  }

  void _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty)
      return;

    if (widget.note == null) {
      await DatabaseHelper.instance.insertNote(
        Note(title: _titleController.text, content: _contentController.text),
      );
    } else {
      await DatabaseHelper.instance.updateNote(
        Note(
          id: widget.note!.id,
          title: _titleController.text,
          content: _contentController.text,
        ),
      );
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Nouvelle Note" : "Modifier Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Titre"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: "Contenu",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmSave,
              child: const Text("Sauvegarder"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
          ],
        ),
      ),
    );
  }
}
