import 'package:flutter/foundation.dart';

import 'book.dart';

class Cart extends ChangeNotifier {
  final Map<Book, int> _qty = {};

  List<Book> get items => List.unmodifiable(_qty.keys);
  int get count => _qty.length;
  int qtyOf(Book book) => _qty[book] ?? 0;
  int get total => _qty.entries.fold(
        0,
        (sum, entry) => sum + entry.key.price * entry.value,
      );

  bool add(Book book) {
    if (_qty.containsKey(book)) return false;
    _qty[book] = 1;
    notifyListeners();
    return true;
  }

  void increment(Book book) {
    if (!_qty.containsKey(book)) return;
    _qty[book] = _qty[book]! + 1;
    notifyListeners();
  }

  void remove(Book book) {
    _qty.remove(book);
    notifyListeners();
  }

  void clear() {
    _qty.clear();
    notifyListeners();
  }
}
