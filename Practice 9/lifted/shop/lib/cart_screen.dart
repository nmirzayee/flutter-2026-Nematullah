import 'package:flutter/material.dart';
import 'models/book.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.items, required this.onRemove});
  final List<Book> items;
  final void Function(Book) onRemove;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cart')),
    body: Column(children: [
      Expanded(child: ListView(children: [
        for (final book in items)
          ListTile(title: Text(book.title), subtitle: Text(book.author),
            trailing: IconButton(icon: const Icon(Icons.close),
              onPressed: () => onRemove(book))),
      ])),
      Padding(padding: const EdgeInsets.all(16),
        child: Text('Total: ${items.fold(0, (sum, b) => sum + b.price)} ₸')),
    ]),
  );
}
