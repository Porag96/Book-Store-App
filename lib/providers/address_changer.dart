import 'package:flutter/foundation.dart';

class ChangeAddress extends ChangeNotifier {
  int _counter = 0;

  int get count => _counter;

  displayAddressResult(int val) {
    _counter = val;
    notifyListeners();
  }
}
