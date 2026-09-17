import 'models.dart';

sealed class ShelfState {
  const ShelfState();
}

class Empty extends ShelfState {
  const Empty();
}

class Ready extends ShelfState {
  final List<Book> books;

  const Ready(this.books);
}

class Broken extends ShelfState {
  final String message;

  const Broken(this.message);
}

String describe(ShelfState state) {
  return switch (state) {
    Empty() => 'The shelf is empty.',
    Ready(:final books) => 'The shelf is ready with ${books.length} books.',
    Broken(:final message) => 'The shelf is broken: $message',
  };
}

({int count, double avgPages}) statsOf(List<Book> books) {
  final totalPages = books.fold<int>(0, (total, book) => total + book.pages);

  final average = books.isEmpty ? 0.0 : totalPages / books.length;

  return (count: books.length, avgPages: average);
}