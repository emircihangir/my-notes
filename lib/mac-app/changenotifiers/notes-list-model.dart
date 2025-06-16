import 'package:flutter/material.dart';
import 'package:mynotes/mac-app/note-widget.dart';

class NotesListModel
    extends
        ChangeNotifier {
  final List<
    Widget
  >
  _notesList = [];

  List<
    Widget
  >
  get notesList => _notesList;

  void addNote(
    BuildContext context, {
    required String noteID,
    String noteContent = "",
  }) {
    _notesList.add(
      noteWidget(
        context,
        id: noteID,
        isOpened: true,
      ),
    );
    notifyListeners();
  }
}
