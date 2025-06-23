import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mynotes/mac-app/changenotifiers/minor-variables-model.dart';
import 'package:mynotes/mac-app/changenotifiers/notes-model.dart';
import 'package:mynotes/mac-app/mac-app.dart';
import 'package:mynotes/android-app.dart';
import 'package:provider/provider.dart';

void main() async {
  if (Platform.isMacOS) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NotesModel()),
          ChangeNotifierProvider(create: (context) => MinorVariablesModel()),
        ],
        builder: (context, child) => MacApp(),
      ),
    );
  } else if (Platform.isAndroid) {
    runApp(androidApp());
  }
}
