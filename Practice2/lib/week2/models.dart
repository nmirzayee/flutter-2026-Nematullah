abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({required this.title, required this.year});

  String describe();

  bool get isOld => year < 2000;
}

class Author {
  final String name;
  final String? country;

  const Author({required this.name, this.country});

  @override
  String toString() {
    return country == null ? name : '$name, $country';
  }
}

enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  final String label;

  const Genre(this.label);

  factory Genre.fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'craft':
        return Genre.craft;
      case 'theory':
        return Genre.theory;
      default:
        return Genre.unknown;
    }
  }
}

mixin Borrowable on LibraryItem {
  String borrowLabel() {
    return 'Borrow "$title"';
  }
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final String title = json['title'] as String? ?? 'Unknown Title';
    final int year = json['year'] as int? ?? 0;
    final int pages = json['pages'] as int? ?? 0;

    final String authorName = json['author'] as String? ?? 'Unknown';

    final String? country = json['country'] as String?;

    final String? genreRaw = json['genre'] as String?;

    final String? description = json['description'] as String?;

    return Book(
      title: title,
      year: year,
      pages: pages,
      author: Author(name: authorName, country: country),
      genre: Genre.fromString(genreRaw),
      description: description,
    );
  }

  bool get isLong => pages > 400;

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String describe() {
    return '$title ($year) — ${author.name}, ${genre.label}';
  }

  @override
  String toString() {
    return 'Book(title: $title, year: $year, pages: $pages, '
        'author: $author, genre: ${genre.label}, '
        'description: ${description ?? 'none'})';
  }
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() {
    return '$title ($year), Issue $issue';
  }
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({required this.title, required this.year});

  @override
  String describe() {
    return 'Ghost item: $title ($year)';
  }

  @override
  bool get isOld => year < 2000;
}