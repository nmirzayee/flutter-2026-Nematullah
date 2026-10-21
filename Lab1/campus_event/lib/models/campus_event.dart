import 'dart:collection';

import 'event_category.dart';

class CampusEvent {
  final String id;
  final String title;
  final EventCategory category;
  final DateTime startsAt;
  final String place;
  final int capacity;
  final bool isOnline;
  final String? description;
  final bool isFavourite;

  final List<String> _attendees;

  List<String> get attendees => UnmodifiableListView(List<String>.of(_attendees));

  const CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.startsAt,
    required this.place,
    required this.capacity,
    required this.isOnline,
    required this.description,
    required this.isFavourite,
    required List<String> attendees,
  }) : _attendees = attendees;

  factory CampusEvent.safe({
    required String id,
    required String title,
    required EventCategory category,
    required DateTime startsAt,
    required String place,
    required int capacity,
    required bool isOnline,
    required String? description,
    required bool isFavourite,
    required List<String> attendees,
  }) {
    return CampusEvent(
      id: id,
      title: title,
      category: category,
      startsAt: startsAt,
      place: place,
      capacity: capacity,
      isOnline: isOnline,
      description: description,
      isFavourite: isFavourite,
      attendees: List.unmodifiable(attendees),
    );
  }

  CampusEvent.empty()
    : id = '',
      title = '',
      category = EventCategory.tech,
      startsAt = DateTime.now().add(const Duration(days: 1)),
      place = '',
      capacity = 1,
      _attendees = const [],
      isOnline = false,
      description = null,
      isFavourite = false;

  int get count => _attendees.length;

  int get freePlaces => capacity - count;

  bool get isFull => count >= capacity;

  bool get isPast => startsAt.isBefore(DateTime.now());

  bool contains(String name) => _attendees.contains(name);

  ({int taken, int free}) get places => (taken: count, free: freePlaces);

  CampusEvent copyWith({
    String? id,
    String? title,
    EventCategory? category,
    DateTime? startsAt,
    String? place,
    int? capacity,
    List<String>? attendees,
    bool? isOnline,
    String? description,
    bool clearDescription = false,
    bool? isFavourite,
  }) {
    return CampusEvent.safe(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      startsAt: startsAt ?? this.startsAt,
      place: place ?? this.place,
      capacity: capacity ?? this.capacity,
      attendees: attendees ?? this.attendees,
      isOnline: isOnline ?? this.isOnline,
      description: clearDescription ? null : description ?? this.description,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
