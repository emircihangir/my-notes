import 'package:flutter/material.dart';
import 'package:mynotes/mac-app/note-widget.dart';

class NoteWidgetsModel
    extends
        ChangeNotifier {
  final List<
    Widget
  >
  _noteWidgets = [];

  List<
    Widget
  >
  get noteWidgets => _noteWidgets;

  void addNote(
    BuildContext context, {
    required String noteID,
    String noteContent = "",
  }) {
    _noteWidgets.add(
      noteWidget(
        context,
        id: noteID,
        isOpened: true,
      ),
    );
    notifyListeners();
  }
}
