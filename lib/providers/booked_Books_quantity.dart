import 'package:flutter/foundation.dart';

class BookedBooksQuantity with ChangeNotifier {
  int _noOfBooks = 0;

  int get noOfBooks => _noOfBooks;

  displayResult(int no) {
    _noOfBooks = no;
    notifyListeners();
  }
}
