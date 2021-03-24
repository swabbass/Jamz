import 'package:flutter/widgets.dart';

class BarsCountSelection with ChangeNotifier {
  int _barsCount = 2;


  BarsCountSelection(this._barsCount);

  set barsCount(int count) {
    if (count != this._barsCount) {
      this._barsCount = count;
      notifyListeners();
    }
  }

  int get barsCount => _barsCount;
}
