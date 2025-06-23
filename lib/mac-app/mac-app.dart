import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mynotes/mac-app/changenotifiers/notes-model.dart';
import 'package:mynotes/mac-app/note-editor.dart';
import 'package:mynotes/mac-app/note-widget.dart';
import 'package:provider/provider.dart';

/// cne: current note editor.
NoteEditor? cne;

class MacApp extends StatelessWidget {
  const MacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Notes",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          fillColor: Colors.black.withAlpha(10),
          filled: true,
          contentPadding: EdgeInsets.all(16),
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.grey,
          cursorColor: Colors.black,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        popupMenuTheme: PopupMenuThemeData(color: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.grey,
          backgroundColor: Colors.white,
          toolbarHeight: 30,
          titleTextStyle: TextStyle(fontSize: 11, color: Colors.black),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("My Notes"),
          actions: [
            IconButton(
              tooltip: "New Note",
              padding: EdgeInsets.all(0),
              onPressed: () {
                Provider.of<NotesModel>(
                  context,
                  listen: false,
                ).addNote(context, noteID: randomID());
              },
              icon: Icon(Icons.add_rounded),
            ),
            IconButton(
              tooltip: "Find",
              padding: EdgeInsets.all(0),
              onPressed: () {},
              icon: Icon(Icons.search_rounded, size: 20),
            ),
            PopupMenuButton(
              padding: EdgeInsetsGeometry.all(0),
              itemBuilder: (context) {
                return [PopupMenuItem(child: Text("Help"))];
              },
            ),
          ],
        ),
        body: appContent(),
      ),
    );
  }
}

Widget appContent() {
  return Padding(
    padding: const EdgeInsetsGeometry.all(8),
    child: SingleChildScrollView(
      child: Consumer<NotesModel>(
        builder: (context, value, child) {
          return Column(
            spacing: 8,
            children: [
              // const MacosSearchField(
              //   placeholder: "Search",
              //   placeholderStyle: TextStyle(
              //     color: MacosColors.placeholderTextColor,
              //   ),
              //   padding: EdgeInsets.all(
              //     8,
              //   ),
              //   maxLines: 1,
              // ),
              ...retrieveNoteWidgets(value.notes, context),
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
List<Widget> retrieveNoteWidgets(Map<String, Map<String, dynamic>> value, BuildContext context) {
  List<Widget> result = [];
  value.forEach((key, value) {
    result.add(
      noteWidget(context, id: key, isOpened: value["isOpened"], content: value["content"]),
    );
  });

  return result;
}

String randomID() {
  final random = Random.secure();
  final chars = 'abcdefghijklmnopqrstuvwxyz0123456789'.split('');

  chars.shuffle(random);
  return chars.join();
}
