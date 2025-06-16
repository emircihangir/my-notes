import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<
  PlatformMenu
>
platformMenus = [
  PlatformMenu(
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
        shortcut: SingleActivator(
          LogicalKeyboardKey.keyN,
          meta: true,
        ),
      ),
    ],
  ),
];
