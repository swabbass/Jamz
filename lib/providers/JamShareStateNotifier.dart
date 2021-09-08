import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:progressions/models/ShareState.dart';

class JamShareStateNotifier with ChangeNotifier {
  ShareState _sharingState = ShareState.INITAL;
  String _desc = "";
  bool _share = false;

  // File? _file = null;

  JamShareStateNotifier(this._sharingState);
  bool get enableUI =>
      _sharingState == ShareState.INITAL || _sharingState == ShareState.ERROR;
  set shareState(ShareState shareState) {
    this._sharingState = shareState;
    notifyListeners();
  }

  bool get share => _share;
  set share(bool share) {
    this._share = share;
    notifyListeners();
  }

  // File? get file => _file;
  // set file(File? file) {
  //   this._file = file;
  //   notifyListeners();
  // }

  String get desc => _desc;
  set desc(String desc) {
    this._desc = desc;
    // notifyListeners();
  }

  ShareState get shareState => _sharingState;
}
