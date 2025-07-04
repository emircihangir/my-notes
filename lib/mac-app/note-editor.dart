import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynotes/mac-app/mac-app.dart';
import 'package:mynotes/mac-app/providers.dart';

class CustomTabIntent extends Intent {
  const CustomTabIntent();
}

class CustomShiftTabIntent extends Intent {
  const CustomShiftTabIntent();
}

class CustomEnterIntent extends Intent {
  const CustomEnterIntent();
}

class OptionBintent extends Intent {
  const OptionBintent();
}

class CmdEnterIntent extends Intent {
  const CmdEnterIntent();
}

class CmdKDIntent extends Intent {
  const CmdKDIntent();
}

class NoteEditor extends ConsumerWidget {
  final String id;
  NoteEditor({super.key, required this.id});

  final TextEditingController teController = TextEditingController();
  final FocusNode fNode = FocusNode();

  int currentIndent() {
    int caretPosition = teController.selection.start;
    if (caretPosition == -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex = teController.text.substring(0, caretPosition).split("\n").length - 1;

    return teController.text.split("\n")[currentRowIndex].split("    ").length - 1;
  }

  String currentLine() {
    int caretPosition = teController.selection.start;
    if (caretPosition == -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex = teController.text.substring(0, caretPosition).split("\n").length - 1;
    List<String> lines = teController.text.split("\n");
    return lines[currentRowIndex];
  }

  void increaseIndent() {
    int caretPosition = teController.selection.start;
    if (caretPosition == -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex = teController.text.substring(0, caretPosition).split("\n").length - 1;
    List<String> lines = teController.text.split("\n");
    String currentLine = lines[currentRowIndex];
    String modifiedLine = "    $currentLine";
    lines[currentRowIndex] = modifiedLine;
    teController.value = TextEditingValue(
      text: lines.join("\n"),
      selection: TextSelection.collapsed(offset: caretPosition + 4),
    );
  }

  void insertAtCaret(String character) {
    int caretPosition = teController.selection.start;
    if (caretPosition == -1) {
      caretPosition = teController.text.length;
    }
    String currentText = teController.text;
    String newText =
        currentText.substring(0, caretPosition) + character + currentText.substring(caretPosition);
    teController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: caretPosition + character.length),
    );
  }

  void decreaseIndent() {
    int caretPosition = teController.selection.start;
    if (caretPosition == -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex = teController.text.substring(0, caretPosition).split("\n").length - 1;
    List<String> lines = teController.text.split("\n");
    String currentLine = lines[currentRowIndex];
    String modifiedLine = currentLine.replaceFirst("    ", "");
    lines[currentRowIndex] = modifiedLine;
    teController.value = TextEditingValue(
      text: lines.join("\n"),
      selection: TextSelection.collapsed(offset: caretPosition - 4),
    );
  }

  Object? enterInvoke(CustomEnterIntent intent) {
    // retrieve current line's values before inserting \n
    bool isList = currentLine().trimLeft().startsWith("- ");
    int ci = currentIndent();

    insertAtCaret("\n");
    insertAtCaret("    " * ci); // preserve indent
    if (isList) {
      insertAtCaret("- ");
    }
    return null;
  }

  void toggleBoldText() {
    String cl = currentLine();
    late String modifiedLine;
    late int cursorOffset;
    if (cl.trimLeft().startsWith("* ")) {
      modifiedLine = cl.replaceFirst("* ", "");
      cursorOffset = -2;
    } else {
      modifiedLine = "${"    " * currentIndent()}* ${cl.trimLeft()}";
      cursorOffset = 2;
    }

    int caretPosition = teController.selection.start;
    if (caretPosition == -1) {
      caretPosition = teController.text.length;
    }
    int currentRowIndex = teController.text.substring(0, caretPosition).split("\n").length - 1;
    List<String> lines = teController.text.split("\n");
    lines[currentRowIndex] = modifiedLine;
    teController.value = TextEditingValue(
      text: lines.join("\n"),
      selection: TextSelection.collapsed(offset: caretPosition + cursorOffset),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    teController.text = ref.read(notesProvider).where((e) => e.id == id).first.content;

    void saveAndCloseNote() {
      ref.read(notesProvider.notifier).updateNoteContent(id, teController.text);
      ref.read(notesProvider.notifier).closeNote(id);
      log("Saved and closed note.\nNote id: $id");
    }

    void deleteNote() {
      ref.read(notesProvider.notifier).removeNote(id);
      log("Deleted note.\nNote id: $id");
    }

    fNode.addListener(() {
      if (fNode.hasFocus == false) {
        saveAndCloseNote();
        cne = null;
      } else {
        cne = this;
      }
    });
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.tab): const CustomTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
            const CustomShiftTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const CustomEnterIntent(),
        LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.keyB): const OptionBintent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.enter): const CmdEnterIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK, LogicalKeyboardKey.keyD):
            const CmdKDIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          CustomTabIntent: CallbackAction<CustomTabIntent>(
            onInvoke: (CustomTabIntent intent) {
              increaseIndent();
              return null;
            },
          ),
          CustomShiftTabIntent: CallbackAction<CustomShiftTabIntent>(
            onInvoke: (CustomShiftTabIntent intent) {
              if (currentIndent() > 0) {
                decreaseIndent();
              }
              return null;
            },
          ),
          CustomEnterIntent: CallbackAction<CustomEnterIntent>(onInvoke: enterInvoke),
          OptionBintent: CallbackAction<OptionBintent>(
            onInvoke: (OptionBintent intent) {
              toggleBoldText();
              return null;
            },
          ),
          CmdEnterIntent: CallbackAction<CmdEnterIntent>(
            onInvoke: (CmdEnterIntent intent) {
              saveAndCloseNote();
              return null;
            },
          ),
          CmdKDIntent: CallbackAction<CmdKDIntent>(
            onInvoke: (CmdKDIntent intent) {
              deleteNote();
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
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
