import 'package:flutter/cupertino.dart';

class NoteContentsModel
    extends
        ChangeNotifier {
  final Map<
    String,
    String
  >
  _noteContents = {};

  Map<
    String,
    String
  >
  get noteContents => _noteContents;

  void updateValue(
    String key,
    String newValue,
  ) {
    _noteContents[key] = newValue;
    notifyListeners();
  }
}
