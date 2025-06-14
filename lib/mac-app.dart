import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

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
              return MacosScaffold(
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
                          return Center(
                            child: Text(
                              "Hi",
                            ),
                          );
                        },
                  ),
                ],
              );
            },
      ),
    ),
  );
}
