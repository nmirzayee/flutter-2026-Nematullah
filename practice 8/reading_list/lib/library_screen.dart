
import 'package:flutter/material.dart';

import 'models/book.dart';
import 'widgets/book_tile.dart';
import 'detail_screen.dart';
import 'add_book_screen.dart';

enum Filter {
  all,
  unread,
  read,
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() =>
      _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];

  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
        Filter.all => _books,
        Filter.unread => unread(_books),
        Filter.read =>
          _books.where((book) => book.read).toList(),
      };

  void _toggleRead(Book book) {
    setState(() {
      book.read = !book.read;
    });
  }

  Future<void> _openDetail(Book book) async {
    final action = await Navigator.of(context)
        .push<BookAction>(
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          book: book,
        ),
      ),
    );

    if (!mounted) return;

    switch (action) {
      case null:
        break;

      case BookAction.toggleRead:
        setState(() {
          book.read = !book.read;
        });

      case BookAction.delete:
        setState(() {
          _books.remove(book);
        });
    }
  }

  Future<void> _addBook() async {
    final book = await Navigator.of(context).push<Book>(
      MaterialPageRoute(
        builder: (context) => const AddBookScreen(),
      ),
    );

    if (!mounted) return;

    if (book == null) return;

    setState(() {
      _books.add(book);
    });
  }

  Widget _stat(
    BuildContext context,
    String label,
    String value,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Row(
          children: [
            _stat(
              context,
              'Books',
              '${_books.length}',
            ),
            _stat(
              context,
              'Pages',
              '${totalPages(_books)}',
            ),
            _stat(
              context,
              'Unread',
              '${unread(_books).length}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final filter in Filter.values)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: ChoiceChip(
              label: Text(
                switch (filter) {
                  Filter.all => 'All',
                  Filter.unread => 'Unread',
                  Filter.read => 'Read',
                },
              ),
              selected: _filter == filter,
              onSelected: (_) {
                setState(() {
                  _filter = filter;
                });
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reading list (${visible.length})',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildFilters(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final book = visible[index];

                  return InkWell(
                    onTap: () => _openDetail(book),
                    child: BookTile(
                      book: book,
                      onToggle: () => _toggleRead(book),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}
