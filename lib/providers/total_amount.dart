import 'package:flutter/foundation.dart';

class TotalMoney extends ChangeNotifier {
  double _totalMoney = 0;

  double get total => _totalMoney;

  display(double totaleMoney) async {
    _totalMoney = totaleMoney;

    await Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
