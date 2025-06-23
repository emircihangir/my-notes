import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynotes/mac-app/changenotifiers/notes-model.dart';
import 'package:mynotes/mac-app/mac-app.dart';
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

class NoteEditor
    extends
        StatelessWidget {
  final String id;
  NoteEditor({
    super.key,
    required this.id,
  });

  final TextEditingController teController = TextEditingController();
  final FocusNode fNode = FocusNode();

  int currentIndent() {
    int caretPosition = teController.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex =
        teController.text
            .substring(
              0,
              caretPosition,
            )
            .split(
              "\n",
            )
            .length -
        1;

    return teController.text
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
    int caretPosition = teController.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex =
        teController.text
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
    lines = teController.text.split(
      "\n",
    );
    return lines[currentRowIndex];
  }

  void increaseIndent() {
    int caretPosition = teController.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex =
        teController.text
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
    lines = teController.text.split(
      "\n",
    );
    String currentLine = lines[currentRowIndex];
    String modifiedLine = "    $currentLine";
    lines[currentRowIndex] = modifiedLine;
    teController.value = TextEditingValue(
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
    int caretPosition = teController.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = teController.text.length;
    }
    String currentText = teController.text;
    String newText =
        currentText.substring(
          0,
          caretPosition,
        ) +
        character +
        currentText.substring(
          caretPosition,
        );
    teController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset:
            caretPosition +
            character.length,
      ),
    );
  }

  void decreaseIndent() {
    int caretPosition = teController.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex =
        teController.text
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
    lines = teController.text.split(
      "\n",
    );
    String currentLine = lines[currentRowIndex];
    String modifiedLine = currentLine.replaceFirst(
      "    ",
      "",
    );
    lines[currentRowIndex] = modifiedLine;
    teController.value = TextEditingValue(
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
    return null;
  }

  void toggleBoldText() {
    String cl = currentLine();
    late String modifiedLine;
    late int cursorOffset;
    if (cl.trimLeft().startsWith(
      "* ",
    )) {
      modifiedLine = cl.replaceFirst(
        "* ",
        "",
      );
      cursorOffset = -2;
    } else {
      modifiedLine = "${"    " * currentIndent()}* ${cl.trimLeft()}";
      cursorOffset = 2;
    }

    int caretPosition = teController.selection.start;
    if (caretPosition ==
        -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex =
        teController.text
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
    lines = teController.text.split(
      "\n",
    );
    lines[currentRowIndex] = modifiedLine;
    teController.value = TextEditingValue(
      text: lines.join(
        "\n",
      ),
      selection: TextSelection.collapsed(
        offset:
            caretPosition +
            cursorOffset,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final notesMap =
        Provider.of<
          NotesModel
        >(
          context,
          listen: false,
        );
    if (notesMap.notes[id] !=
        null) {
      teController.text = notesMap.notes[id]!["content"];
    } else {
      throw Exception(
        "The given noteID does not exist in the _notes map. \nGiven noteID: $id \n_notes map: $notesMap",
      );
    }

    void saveAndCloseNote() {
      Provider.of<
            NotesModel
          >(
            context,
            listen: false,
          )
          .updateNoteContent(
            id,
            teController.text,
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
    }

    void deleteNote() {
      log(
        "deleting note",
      );
    }

    fNode.addListener(
      () {
        if (fNode.hasFocus ==
            false) {
          saveAndCloseNote();
          cne = null;
        } else {
          cne = this;
        }
      },
    );
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
                          toggleBoldText();
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
                          saveAndCloseNote();
                          return null;
                        },
                  ),
            },
        child: TextField(
          focusNode: fNode,
          maxLines: null,
          autofocus: true,
          controller: teController,
          cursorColor: Colors.black,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
