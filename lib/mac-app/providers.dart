import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynotes/mac-app/mac-app.dart';
import 'package:mynotes/mac-app/note-class.dart';

class NotesNotifier extends Notifier<List<Note>> {
  @override
  List<Note> build() => [];

  void closeNote(String noteID) {
    List<Note> stateCopy = state.toList();
    stateCopy.where((e) => e.id == noteID).first.isOpened = false;
    state = stateCopy;
  }

  void openNote(String noteID) {
    List<Note> stateCopy = state.toList();
    stateCopy.where((e) => e.id == noteID).first.isOpened = true;
    state = stateCopy;
  }

  void updateNoteContent(String noteID, String newValue) {
    List<Note> stateCopy = state.toList();
    stateCopy.where((e) => e.id == noteID).first.content = newValue;
    state = stateCopy;
  }

  void addNote({required String noteID, String noteContent = ""}) {
    Note newNote = Note(id: randomID(), isOpened: true);
    List<Note> stateCopy = state.toList();
    stateCopy.add(newNote);
    state = stateCopy;
  }

  void removeNote(String id) {
    List<Note> stateCopy = state.toList();
    stateCopy.removeWhere((e) => e.id == id);
    state = stateCopy;
  }
}

final notesProvider = NotifierProvider<NotesNotifier, List<Note>>(() => NotesNotifier());
