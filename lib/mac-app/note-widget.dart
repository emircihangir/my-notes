import 'package:flutter/material.dart';
import 'package:mynotes/mac-app/changenotifiers/notes-model.dart';
import 'package:mynotes/mac-app/note-editor.dart';
import 'package:mynotes/mac-app/text-renderer-widget.dart';
import 'package:provider/provider.dart';

Widget noteCard({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: Colors.grey.shade300, width: 1.3),
    ),
    child: child,
  );
}

Widget noteWidget(
  BuildContext context, {
  required String id,
  bool isOpened = false,
  String content = "",
}) {
  return Row(
    spacing: 8,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      isOpened
          ? Expanded(child: NoteEditor(id: id))
          : Expanded(
              child: GestureDetector(
                onTap: () {
                  Provider.of<NotesModel>(context, listen: false).openNote(id);
                },
                child: noteCard(
                  child: Selector<NotesModel, String?>(
                    selector: (p0, p1) {
                      if (p1.notes[id] != null) {
                        return p1.notes[id]!["content"];
                      } else {
                        throw Exception(
                          "The given noteID does not exist in the _notes map. \nGiven noteID: $id \n_notes map: ${p1.notes}",
                        );
                      }
                    },
                    builder: (context, value, child) {
                      return textRenderer(data: value ?? "");
                    },
                  ),
                ),
              ),
            ),
    ],
  );
}
