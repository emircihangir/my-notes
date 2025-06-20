import 'package:flutter/material.dart';
import 'package:mynotes/mac-app/changenotifiers/note-contents-model.dart';
import 'package:mynotes/mac-app/note-editor.dart';
import 'package:mynotes/mac-app/text-renderer-widget.dart';
import 'package:provider/provider.dart';

Widget
noteCard({
  required Widget child,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromRGBO(
        0,
        0,
        0,
        0.2,
      ),
      borderRadius: BorderRadius.circular(
        7,
      ),
    ),
    child: child,
  );
}

Widget
noteWidget(
  BuildContext context, {
  required String id,
  bool isOpened = false,
  String content = "",
}) {
  return Selector<
    NoteContentsModel,
    String?
  >(
    selector:
        (
          p0,
          p1,
        ) => p1.noteContents[id],
    builder:
        (
          context,
          value,
          child,
        ) {
          return Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isOpened
                  ? Expanded(
                      child: noteEditor(
                        context,
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: noteCard(
                  child: textRenderer(
                    data:
                        value ??
                        "",
                  ),
                ),
              ),
            ],
          );
        },
  );
}
