import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../widgets/event_card.dart';
import '../widgets/empty_state.dart';

class FavouritesScreen extends StatelessWidget {
  final List<CampusEvent> events;
  final ValueChanged<CampusEvent> onFavourite;
  final ValueChanged<CampusEvent> onOpenCampusEvent;
  final VoidCallback onBrowseEvents;

  const FavouritesScreen({
    super.key,
    required this.events,
    required this.onFavourite,
    required this.onOpenCampusEvent,
    required this.onBrowseEvents,
  });

  @override
  Widget build(BuildContext context) {
    final favourites = events.where((event) => event.isFavourite).toList();

    if (favourites.isEmpty) {
      return EmptyState(
        icon: Icons.favorite_border,
        message: 'You have no favourite events yet.',
        buttonLabel: 'Browse events',
        onPressed: onBrowseEvents,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: favourites.length,
      itemBuilder: (context, index) {
        final event = favourites[index];

        return EventCard(
          event: event,
          onTap: () => onOpenCampusEvent(event),
          onFavourite: () => onFavourite(event),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 8),
    );
  }
}
