import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('Remove all books from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (confirmed == true) context.read<Cart>().clear();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          actions: [
            IconButton(
              tooltip: 'Clear cart',
              onPressed: () => _confirmClear(context),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<Cart>(
                builder: (context, cart, _) {
                  if (cart.items.isEmpty) {
                    return const Center(child: Text('Your cart is empty'));
                  }
                  return ListView(
                    children: [
                      for (final book in cart.items)
                        ListTile(
                          title: Text(book.title),
                          subtitle: Text('${book.price} ₸ × ${cart.qtyOf(book)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('×${cart.qtyOf(book)}'),
                              IconButton(
                                tooltip: 'Increase quantity',
                                onPressed: () => cart.increment(book),
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                tooltip: 'Remove book',
                                onPressed: () => cart.remove(book),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<Cart>(
                child: const _TotalLabel(),
                builder: (context, cart, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    child!,
                    Text(
                      '${cart.total} ₸',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _TotalLabel extends StatelessWidget {
  const _TotalLabel();

  @override
  Widget build(BuildContext context) => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined),
          SizedBox(width: 8),
          Text('Total'),
        ],
      );
}
