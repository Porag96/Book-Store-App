import 'package:book_store/service/service.dart';
import 'package:flutter/foundation.dart';

class CountBookOnCart extends ChangeNotifier {
  int _counter =
      BookStore.sharedPreferences!.getStringList(BookStore.userCart)!.length -
          1;
  int get count => _counter;

  Future<void> countBook() async {
    int _counter =
        BookStore.sharedPreferences!.getStringList(BookStore.userCart)!.length -
            1;
    await Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
