import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mynotes/mac-app.dart';
import 'package:mynotes/android-app.dart';

void
main() {
  if (Platform.isMacOS) {
    runApp(
      macApp(),
    );
  } else if (Platform.isAndroid) {
    runApp(
      androidApp(),
    );
  }
}
