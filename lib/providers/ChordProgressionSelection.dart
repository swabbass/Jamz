import 'package:flutter/widgets.dart';

class ChordProgressionSelection with ChangeNotifier {
  Map<int, int> _chordsSelection = <int, int>{};

  ChordProgressionSelection(this._chordsSelection);

  set chordsSelection(Map<int, int> chordsSelection) {
    this._chordsSelection = chordsSelection;
    notifyListeners();
  }

  Map<int, int> get chordsSelection => _chordsSelection;
}
