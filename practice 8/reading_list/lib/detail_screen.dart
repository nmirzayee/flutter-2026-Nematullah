
import 'package:flutter/material.dart';

import 'models/book.dart';

enum BookAction {
  toggleRead,
  delete,
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.book,
  });

  final Book book;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Delete '${book.title}'?"),
          content: const Text(
            'Are you sure you want to delete this book?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      Navigator.of(context).pop(BookAction.delete);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text('Author: ${book.author}'),
            const SizedBox(height: 12),
            Text('Pages: ${book.pages}'),
            const SizedBox(height: 12),
            Text(
              book.year == null
                  ? 'Year unknown'
                  : 'Year: ${book.year}',
            ),
            const SizedBox(height: 12),
            Text(
              'Status: ${book.read ? 'Read' : 'Unread'}',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(
                  BookAction.toggleRead,
                );
              },
              child: Text(
                book.read
                    ? 'Mark as unread'
                    : 'Mark as read',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _confirmDelete(context),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
