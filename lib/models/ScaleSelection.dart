import 'package:flutter/foundation.dart';
import 'package:progressions/models/Notes.dart';

import 'Modes.dart';
import 'Scale.dart';

class SelectedScaleNotifier with ChangeNotifier {
  Scale? _selectedScale;
  Note? _selectedKey;
  ScaleMode? _selectedMode;
  late bool _sharps;

  SelectedScaleNotifier(Note selectedKey, ScaleMode selectedMode, bool sharps) {
    this._selectedKey = selectedKey;
    this._selectedMode = selectedMode;
    this._selectedScale = Scale(_selectedMode, _selectedKey);
    this._sharps = sharps;
  }

  Scale get selectedScale => _selectedScale!;

  Note get selectedKey => _selectedKey!;

  ScaleMode? get selectedMode => _selectedMode;

  bool get sharps => _sharps;

  set selectedMode(ScaleMode? value) {
    if (_selectedMode != value) {
      this._selectedScale = Scale(value, _selectedKey);
      this._selectedMode = value;
      notifyListeners();
    } else {
      print("no notify");
    }
  }

  set selectedKey(Note? value) {
    if (_selectedKey != value) {
      this._selectedScale = Scale(_selectedMode, value);
      this._selectedKey = value;
      notifyListeners();
    } else {
      print("no notify");
    }
  }

  set sharps(bool value) {
    if(value){
      NOTES_NAMES= NOTES_NAMES_SHARPS;
    }else{
      NOTES_NAMES= NOTES_NAMES_FLATS;
    }
    _sharps = value;
    this._selectedScale = Scale(_selectedMode, _selectedKey);
    notifyListeners();
  }
}
