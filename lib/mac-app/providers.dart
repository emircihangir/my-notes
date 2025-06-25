import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends Notifier<Map> {
  @override
  Map build() => {};

  void closeNote(String noteID) {
    if (state[noteID] != null) {
      state[noteID]!["isOpened"] = false;
    } else {
      throw Exception(
        "The given noteID does not exist in the notes map. \nGiven noteID: $noteID \nstate map: $state",
      );
    }
  }

  void openNote(String noteID) {
    if (state[noteID] != null) {
      state[noteID]!["isOpened"] = true;
    } else {
      throw Exception(
        "The given noteID does not exist in the notes map. \nGiven noteID: $noteID \nstate map: $state",
      );
    }
  }

  void updateNoteContent(String noteID, String newValue) {
    if (state[noteID] != null) {
      state[noteID]!["content"] = newValue;
    } else {
      throw Exception(
        "The given noteID does not exist in the notes map. \nGiven noteID: $noteID \nstate map: $state",
      );
    }
  }

  void addNote({required String noteID, String noteContent = ""}) {
    state[noteID] = {"id": noteID, "isOpened": true, "content": noteContent};
  }

  void removeNote(String id) {
    state.remove(id);
  }
}

final notesProvider = NotifierProvider<NotesNotifier, Map>(() => NotesNotifier());
