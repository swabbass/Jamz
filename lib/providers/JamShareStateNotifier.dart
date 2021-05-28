import 'package:flutter/widgets.dart';
import 'package:progressions/models/ShareState.dart';

class JamShareStateNotifier with ChangeNotifier {
  ShareState _sharingState = ShareState.INITAL;

  JamShareStateNotifier(this._sharingState);
  bool get enableUI =>
      _sharingState == ShareState.INITAL || _sharingState == ShareState.ERROR;
  set shareState(ShareState shareState) {
    this._sharingState = shareState;
    notifyListeners();
  }

  ShareState get shareState => _sharingState;
}
