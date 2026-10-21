import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../models/event_category.dart';
import '../widgets/event_card.dart';
import '../widgets/empty_state.dart';

class EventsScreen extends StatefulWidget {
  final List<CampusEvent> events;
  final ValueChanged<CampusEvent> onFavourite;
  final ValueChanged<CampusEvent> onOpenCampusEvent;
  final VoidCallback onAddCampusEvent;

  const EventsScreen({
    super.key,
    required this.events,
    required this.onFavourite,
    required this.onOpenCampusEvent,
    required this.onAddCampusEvent,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();

  EventCategory? _selectedCategory;
  bool _showPast = false;
  bool _onlineOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CampusEvent> get _filteredEvents {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = widget.events.where((event) {
      final matchesSearch = event.title.toLowerCase().contains(query);
    //   final matchesSearch =
    // event.title.toLowerCase().contains(query) ||
    // event.place.toLowerCase().contains(query);
    final matchesOnline =
    !_onlineOnly || event.isOnline;

      final matchesCategory =
          _selectedCategory == null || event.category == _selectedCategory;

      final matchesPast = _showPast || !event.isPast;

      return matchesSearch && matchesCategory && matchesPast;
    }).toList();

    filtered.sort((a, b) {
      if (a.isPast != b.isPast) {
        return a.isPast ? 1 : -1;
      }
      return a.startsAt.compareTo(b.startsAt);
    });




//     filtered.sort((a, b) {
//   if (a.isPast != b.isPast) {
//     return a.isPast ? 1 : -1;
//   }

//   return a.title.toLowerCase().compareTo(
//     b.title.toLowerCase(),
//   );
// });

    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _showPast = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = _filteredEvents;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Search events',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear),
                    ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedCategory == null,
                onSelected: (_) {
                  setState(() => _selectedCategory = null);
                },
              ),
              const SizedBox(width: 8),
              for (final category in EventCategory.values) ...[
                ChoiceChip(
                  label: Text(category.label),
                  selected: _selectedCategory == category,
                  onSelected: (_) {
                    setState(() => _selectedCategory = category);
                  },
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              label: const Text('Include past events'),
              selected: _showPast,
              onSelected: (value) {
                setState(() => _showPast = value);
              },
            ),
          ),
        ),
        Expanded(
          child: events.isEmpty
              ? EmptyState(
                  icon: Icons.event,
                  message: 'No matching events found',
                  buttonLabel: 'Clear filters',
                  onPressed: _clearFilters,
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    if (width < 600) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return EventCard(
                            event: event,
                            onTap: () => widget.onOpenCampusEvent(event),
                            onFavourite: () => widget.onFavourite(event),
                          );
                        },
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                      );
                    }

                    final columns = (width / 360).ceil().clamp(2, 6);

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 210,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return EventCard(
                          event: event,
                          onTap: () => widget.onOpenCampusEvent(event),
                          onFavourite: () => widget.onFavourite(event),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
