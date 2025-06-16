import 'package:flutter/material.dart';
import 'package:mynotes/mac-app/note-editor.dart';
import 'package:mynotes/mac-app/text-renderer-widget.dart';

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
            data: "",
          ),
        ),
      ),
    ],
  );
}
