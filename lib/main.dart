import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynotes/mac-app/mac-app.dart';
import 'package:mynotes/android-app.dart';

void main() async {
  if (Platform.isMacOS) {
    runApp(ProviderScope(child: MacApp()));
  } else if (Platform.isAndroid) {
    runApp(ProviderScope(child: androidApp()));
  }
}
