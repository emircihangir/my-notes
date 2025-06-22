import 'dart:math';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mynotes/mac-app/changenotifiers/notes-model.dart';
import 'package:mynotes/mac-app/note-editor.dart';
import 'package:mynotes/mac-app/note-widget.dart';
import 'package:mynotes/mac-app/platform-menus.dart';
import 'package:provider/provider.dart';

/// cne: current note editor.
NoteEditor?
cne;

Widget
macApp() {
  return MacosApp(
    title: "My Notes",
    theme: MacosThemeData.light(),
    darkTheme: MacosThemeData.dark(),
    themeMode: ThemeMode.system,
    home: MacosWindow(
      child: Builder(
        builder:
            (
              context,
            ) {
              return PlatformMenuBar(
                menus: platformMenus(
                  context,
                ),
                child: MacosScaffold(
                  toolBar: const ToolBar(
                    title: Text(
                      'My Notes',
                      textAlign: TextAlign.center,
                    ),
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                  ),
                  children: [
                    ContentArea(
                      builder:
                          (
                            context,
                            scrollController,
                          ) {
                            return appContent(
                              context,
                            );
                          },
                    ),
                  ],
                ),
              );
            },
      ),
    ),
  );
}

Widget
appContent(
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsetsGeometry.all(
      8,
    ),
    child: SingleChildScrollView(
      child:
          Consumer<
            NotesModel
          >(
            builder:
                (
                  context,
                  value,
                  child,
                ) {
                  return Column(
                    spacing: 8,
                    children: [
                      const MacosSearchField(
                        placeholder: "Search",
                        placeholderStyle: TextStyle(
                          color: MacosColors.placeholderTextColor,
                        ),
                        padding: EdgeInsets.all(
                          8,
                        ),
                        maxLines: 1,
                      ),
                      ...retrieveNoteWidgets(
                        value.notes,
                        context,
                      ),
                    ],
                  );
                },
          ),
    ),
  );
}

/// Generates a list of widgets based on the given notes map.
///
/// This function is dependent on the NotesModel changenotifier class.
List<
  Widget
>
retrieveNoteWidgets(
  Map<
    String,
    Map<
      String,
      dynamic
    >
  >
  value,
  BuildContext context,
) {
  List<
    Widget
  >
  result = [];
  value.forEach(
    (
      key,
      value,
    ) {
      result.add(
        noteWidget(
          context,
          id: key,
          isOpened: value["isOpened"],
          content: value["content"],
        ),
      );
    },
  );

  return result;
}

String
randomID() {
  final random = Random.secure();
  final chars = 'abcdefghijklmnopqrstuvwxyz0123456789'.split(
    '',
  );

  chars.shuffle(
    random,
  );
  return chars.join();
}
