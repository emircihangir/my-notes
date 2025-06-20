import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mynotes/mac-app/changenotifiers/notes-model.dart';
import 'package:provider/provider.dart';

class CustomTabIntent
    extends
        Intent {
  const CustomTabIntent();
}

class CustomShiftTabIntent
    extends
        Intent {
  const CustomShiftTabIntent();
}

class CustomEnterIntent
    extends
        Intent {
  const CustomEnterIntent();
}

class OptionBintent
    extends
        Intent {
  const OptionBintent();
}

class CmdEnterIntent
    extends
        Intent {
  const CmdEnterIntent();
}

Widget
noteEditor(
  BuildContext context,
  String id,
) {
  var c = TextEditingController();
  final notesMap =
      Provider.of<
        NotesModel
      >(
        context,
        listen: false,
      );
  if (notesMap.notes[id] !=
      null) {
    c.text = notesMap.notes[id]!["content"];
  } else {
    throw Exception(
      "The given noteID does not exist in the _notes map. \nGiven noteID: $id \n_notes map: $notesMap",
    );
  }

  int currentIndent() {
    int caretPosition = c.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = c.text.length;
    }
    int currentRowIndex =
        c.text
            .substring(
              0,
              caretPosition,
            )
            .split(
              "\n",
            )
            .length -
        1;

    return c.text
            .split(
              "\n",
            )[currentRowIndex]
            .split(
              "    ",
            )
            .length -
        1;
  }

  String currentLine() {
    int caretPosition = c.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = c.text.length;
    }
    int currentRowIndex =
        c.text
            .substring(
              0,
              caretPosition,
            )
            .split(
              "\n",
            )
            .length -
        1;
    List<
      String
    >
    lines = c.text.split(
      "\n",
    );
    return lines[currentRowIndex];
  }

  void increaseIndent() {
    int caretPosition = c.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = c.text.length;
    }
    int currentRowIndex =
        c.text
            .substring(
              0,
              caretPosition,
            )
            .split(
              "\n",
            )
            .length -
        1;
    List<
      String
    >
    lines = c.text.split(
      "\n",
    );
    String currentLine = lines[currentRowIndex];
    String modifiedLine = "    $currentLine";
    lines[currentRowIndex] = modifiedLine;
    c.value = TextEditingValue(
      text: lines.join(
        "\n",
      ),
      selection: TextSelection.collapsed(
        offset:
            caretPosition +
            4,
      ),
    );
  }

  void insertAtCaret(
    String character,
  ) {
    int caretPosition = c.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = c.text.length;
    }
    String currentText = c.text;
    String newText =
        currentText.substring(
          0,
          caretPosition,
        ) +
        character +
        currentText.substring(
          caretPosition,
        );
    c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset:
            caretPosition +
            character.length,
      ),
    );
  }

  void decreaseIndent() {
    int caretPosition = c.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = c.text.length;
    }
    int currentRowIndex =
        c.text
            .substring(
              0,
              caretPosition,
            )
            .split(
              "\n",
            )
            .length -
        1;
    List<
      String
    >
    lines = c.text.split(
      "\n",
    );
    String currentLine = lines[currentRowIndex];
    String modifiedLine = currentLine.replaceFirst(
      "    ",
      "",
    );
    lines[currentRowIndex] = modifiedLine;
    c.value = TextEditingValue(
      text: lines.join(
        "\n",
      ),
      selection: TextSelection.collapsed(
        offset:
            caretPosition -
            4,
      ),
    );
  }

  Object? enterInvoke(
    CustomEnterIntent intent,
  ) {
    // retrieve current line's values before inserting \n
    bool isList = currentLine().trimLeft().startsWith(
      "- ",
    );
    int ci = currentIndent();

    insertAtCaret(
      "\n",
    );
    insertAtCaret(
      "    " *
          ci,
    ); // preserve indent
    if (isList) {
      insertAtCaret(
        "- ",
      );
    }

    // Provider.of<tfModel>(context, listen: false).content = c.text;
    return null;
  }

  return Shortcuts(
    shortcuts:
        <
          LogicalKeySet,
          Intent
        >{
          LogicalKeySet(
            LogicalKeyboardKey.tab,
          ): const CustomTabIntent(),
          LogicalKeySet(
            LogicalKeyboardKey.shift,
            LogicalKeyboardKey.tab,
          ): const CustomShiftTabIntent(),
          LogicalKeySet(
            LogicalKeyboardKey.enter,
          ): const CustomEnterIntent(),
          LogicalKeySet(
            LogicalKeyboardKey.alt,
            LogicalKeyboardKey.keyB,
          ): const OptionBintent(),
          LogicalKeySet(
            LogicalKeyboardKey.meta,
            LogicalKeyboardKey.enter,
          ): const CmdEnterIntent(),
        },
    child: Actions(
      actions:
          <
            Type,
            Action<
              Intent
            >
          >{
            CustomTabIntent:
                CallbackAction<
                  CustomTabIntent
                >(
                  onInvoke:
                      (
                        CustomTabIntent intent,
                      ) {
                        increaseIndent();
                        // Provider.of<tfModel>(context, listen: false).content = c.text;
                        return null;
                      },
                ),
            CustomShiftTabIntent:
                CallbackAction<
                  CustomShiftTabIntent
                >(
                  onInvoke:
                      (
                        CustomShiftTabIntent intent,
                      ) {
                        if (currentIndent() >
                            0) {
                          decreaseIndent();
                        }
                        // Provider.of<tfModel>(context, listen: false).content = c.text;
                        return null;
                      },
                ),
            CustomEnterIntent:
                CallbackAction<
                  CustomEnterIntent
                >(
                  onInvoke: enterInvoke,
                ),
            OptionBintent:
                CallbackAction<
                  OptionBintent
                >(
                  onInvoke:
                      (
                        OptionBintent intent,
                      ) {
                        // retrieve current line's values before inserting \n
                        return null;
                      },
                ),
            CmdEnterIntent:
                CallbackAction<
                  CmdEnterIntent
                >(
                  onInvoke:
                      (
                        CmdEnterIntent intent,
                      ) {
                        Provider.of<
                              NotesModel
                            >(
                              context,
                              listen: false,
                            )
                            .updateNoteContent(
                              id,
                              c.text,
                            );
                        Provider.of<
                              NotesModel
                            >(
                              context,
                              listen: false,
                            )
                            .closeNote(
                              id,
                            );
                        return null;
                      },
                ),
          },
      child: MacosTextField(
        maxLines: null,
        expands: true,
        autofocus: true,
        controller: c,
        padding: const EdgeInsets.all(
          16,
        ),
        textAlignVertical: const TextAlignVertical(
          y: -1,
        ),
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    ),
  );
}
