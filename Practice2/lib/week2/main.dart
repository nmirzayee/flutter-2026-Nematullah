import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  // Build the library from rawBooks using Book.fromJson.
  final books = rawBooks.map(Book.fromJson).toList();

  final library = Library();

  for (final book in books) {
    library.add(book);
  }

  library.open();

  print('===== LIBRARY CATALOGUE =====');
  print('\n');

  print('Every title:');
  print(library.everyTitle);
  print('\n');

  print('Books after 2010:');
  print(library.booksAfter2010.map((book) => book.title).toList());
  print('\n');

  print('Average pages:');
  print(library.averagePages);
  print('\n');

  print('Books by author:');
  print(library.booksByAuthor);
  print('\n');

  print('Distinct authors:');
  print(library.distinctAuthors);
  print('\n');

  print('Genres present:');
  print(library.genresPresent);
  print('\n');

  print('Country of Clean Code:');
  print(library.countryOf('Clean Code'));
  print('\n');

  print('Country of Design Patterns:');
  print(library.countryOf('Design Patterns'));
  print('\n');

  print('Country of Unknown Book:');
  print(library.countryOf('Unknown Book'));
  print('\n');

  print('Cached report:');
  print(library.report);
  print('\n');

  print('Display list:');
  for (final line in library.displayList) {
    print(line);
  }

  print('\n');

  print('===== RECORD =====');

  final stats = statsOf(books);

  print('Count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');

  print('\n');

  print('===== SHELF STATES =====');

  final ShelfState empty = const Empty();
  final ShelfState ready = Ready(books);
  final ShelfState broken = const Broken('Catalogue database unavailable');

  print(describe(empty));
  print(describe(ready));
  print(describe(broken));

  print('\n');

  print('===== BOOK DETAILS =====');

  for (final book in books) {
    print(book);
    print('Long book: ${book.isLong}');
    print('Old item: ${book.isOld}');
    print('Borrow label: ${book.borrowLabel()}');
    print('\n');
  }
}