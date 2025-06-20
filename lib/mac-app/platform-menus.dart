import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynotes/mac-app/changenotifiers/note-widget-model.dart';
import 'package:mynotes/mac-app/mac-app.dart';
import 'package:provider/provider.dart';

List<
  PlatformMenu
>
platformMenus(
  BuildContext context,
) => [
  const PlatformMenu(
    label: "",
    menus: [
      PlatformProvidedMenuItem(
        type: PlatformProvidedMenuItemType.about,
      ),
      PlatformProvidedMenuItem(
        type: PlatformProvidedMenuItemType.hide,
      ),
      PlatformProvidedMenuItem(
        type: PlatformProvidedMenuItemType.hideOtherApplications,
      ),
      PlatformProvidedMenuItem(
        type: PlatformProvidedMenuItemType.quit,
      ),
    ],
  ),
  PlatformMenu(
    label: "Notes",
    menus: [
      PlatformMenuItem(
        label: "New Note",
        shortcut: const SingleActivator(
          LogicalKeyboardKey.keyN,
          meta: true,
        ),
        onSelected: () {
          Provider.of<
                NoteWidgetsModel
              >(
                context,
                listen: false,
              )
              .addNote(
                context,
                noteID: randomID(),
              );
        },
      ),
    ],
  ),
];
