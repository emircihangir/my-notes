import 'dart:io';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mynotes/mac-app/changenotifiers/note-widget-model.dart';
import 'package:mynotes/mac-app/mac-app.dart';
import 'package:mynotes/android-app.dart';
import 'package:provider/provider.dart';

/// This method initializes macos_window_utils and styles the window.
Future<
  void
>
_configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

Future<
  void
>
main() async {
  if (Platform.isMacOS) {
    await _configureMacosWindowUtils();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create:
                (
                  context,
                ) => NoteWidgetsModel(),
          ),
        ],
        builder:
            (
              context,
              child,
            ) => macApp(),
      ),
    );
  } else if (Platform.isAndroid) {
    runApp(
      androidApp(),
    );
  }
}
