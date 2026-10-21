import 'package:flutter/material.dart';

enum EventCategory {
  music('Music', Icons.music_note),
  tech('Technology', Icons.computer),
  sports('Sports', Icons.sports_soccer),
  arts('Arts', Icons.palette),
  science('Science', Icons.science),
  community('Community', Icons.groups);

  const EventCategory(this.label, this.icon);
  final String label;
  final IconData icon;

  Color color(ColorScheme scheme) => switch (this) {
    EventCategory.tech => scheme.primary,
    EventCategory.sports => scheme.secondary,
    EventCategory.arts => scheme.tertiary,
    EventCategory.science => scheme.onPrimaryContainer,
    EventCategory.community => scheme.onSecondaryContainer,
    EventCategory.music => scheme.primaryContainer,
  };
}
