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
                          return appContent(
                            context,
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

Widget
appContent(
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsetsGeometry.all(
      8,
    ),
    child: SingleChildScrollView(
      child: Column(
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
        ],
      ),
    ),
  );
}
