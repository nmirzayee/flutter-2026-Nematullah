import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/format.dart';

class EventCard extends StatelessWidget {
  final CampusEvent event;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (:taken, :free) = event.places;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: event.category.color(scheme),
                    child: Icon(event.category.icon, color: scheme.surface),
                  ),
                  if (event.isFull || free <= 5)
                    Positioned(
                      bottom: -8,
                      right: -12,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: scheme.errorContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.isFull ? 'FULL' : '$free left',
                          style: TextStyle(color: scheme.onErrorContainer),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(event.category.label),
                    Text(formatDate(event.startsAt)),
                    Text(
                      event.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('$taken registered'),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Toggle favourite',
                onPressed: onFavourite,
                icon: Icon(
                  event.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
