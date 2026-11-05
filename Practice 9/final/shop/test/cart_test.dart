import 'package:flutter_test/flutter_test.dart';
import 'package:shop/models/book.dart';
import 'package:shop/models/cart.dart';

void main() {
  test('adding, rejecting duplicate, and removing', () {
    final cart = Cart();
    expect(cart.add(books[0]), isTrue);
    expect(cart.add(books[1]), isTrue);
    expect(cart.add(books[0]), isFalse);
    expect(cart.count, 2);
    expect(cart.total, 7300);
    cart.remove(books[0]);
    expect(cart.count, 1);
    expect(cart.total, 3100);
  });

  test('quantity changes total but not distinct count', () {
    final cart = Cart();
    cart.add(books[1]);
    cart.increment(books[1]);
    expect(cart.count, 1);
    expect(cart.qtyOf(books[1]), 2);
    expect(cart.total, 6200);
    expect(() => cart.items.add(books[0]), throwsUnsupportedError);
    cart.clear();
    expect(cart.count, 0);
    expect(cart.total, 0);
  });
}
