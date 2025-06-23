import 'package:flutter/widgets.dart';

class NotesModel extends ChangeNotifier {
  final Map<String, Map<String, dynamic>> _notes = {};

  Map<String, Map<String, dynamic>> get notes => _notes;

  void closeNote(String noteID) {
    if (_notes[noteID] != null) {
      _notes[noteID]!["isOpened"] = false;
    } else {
      throw Exception(
        "The given noteID does not exist in the _notes map. \nGiven noteID: $noteID \n_notes map: $_notes",
      );
    }
    notifyListeners();
  }

  void openNote(String noteID) {
    if (_notes[noteID] != null) {
      _notes[noteID]!["isOpened"] = true;
    } else {
      throw Exception(
        "The given noteID does not exist in the _notes map. \nGiven noteID: $noteID \n_notes map: $_notes",
      );
    }
    notifyListeners();
  }

  void updateNoteContent(String noteID, String newValue) {
    if (_notes[noteID] != null) {
      _notes[noteID]!["content"] = newValue;
    } else {
      throw Exception(
        "The given noteID does not exist in the _notes map. \nGiven noteID: $noteID \n_notes map: $_notes",
      );
    }
    notifyListeners();
  }

  void addNote(BuildContext context, {required String noteID, String noteContent = ""}) {
    _notes[noteID] = {"id": noteID, "isOpened": true, "content": noteContent};
    notifyListeners();
  }

  void removeNote(String id) {
    _notes.remove(id);
    notifyListeners();
  }
}
