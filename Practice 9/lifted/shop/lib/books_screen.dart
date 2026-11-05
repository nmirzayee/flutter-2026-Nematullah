import 'package:flutter/material.dart';
import 'cart_badge.dart';
import 'models/book.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key, required this.cart, required this.onAdd,
      required this.total});
  final List<Book> cart;
  final void Function(Book) onAdd;
  final int total;

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');
    return Scaffold(
      appBar: AppBar(title: const Text('Books'), actions: [
        CartBadge(count: cart.length, total: total),
      ]),
      body: ListView(children: [
        for (final book in books) ...[
          Builder(builder: (context) {
            debugPrint('row ${book.title}');
            return ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              trailing: cart.contains(book)
                  ? const Text('Added')
                  : OutlinedButton(onPressed: () => onAdd(book),
                      child: const Text('Add')),
            );
          }),
        ],
      ]),
    );
  }
}
