import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynotes/mac-app/note-editor.dart';
import 'package:mynotes/mac-app/providers.dart';
import 'package:mynotes/mac-app/text-renderer-widget.dart';

Widget noteCard({required Widget child}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: Colors.grey.shade300, width: 1.3),
    ),
    child: child,
  );
}

Widget noteWidget({required String id, bool isOpened = false, String content = ""}) {
  return Row(
    spacing: 8,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      isOpened
          ? Expanded(child: NoteEditor(id: id))
          : Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final thisNote = ref.watch(notesProvider).where((e) => e.id == id).first;

                  return GestureDetector(
                    onTap: () {
                      ref.read(notesProvider.notifier).openNote(id);
                    },
                    child: noteCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: textRenderer(data: thisNote.content),
                      ),
                    ),
                  );
                },
              ),
            ),
    ],
  );
}
