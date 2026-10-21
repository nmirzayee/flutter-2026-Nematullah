import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../screens/event_detail_screen.dart';
import '../screens/event_form_screen.dart';

class Routes {
  static const String shell = '/';
  static const String detail = '/detail';
  static const String form = '/form';
}

class EventDetailArguments {
  final CampusEvent event;
  final CampusEvent Function(String id) getCurrentCampusEvent;
  final String Function() getProfileName;
  final ValueChanged<CampusEvent> onRegister;
  final ValueChanged<CampusEvent> onUnregister;
  final ValueChanged<CampusEvent> onDelete;
  final Future<void> Function(CampusEvent) onEdit;
  final VoidCallback onProfileRequested;

  const EventDetailArguments({
    required this.event,
    required this.getCurrentCampusEvent,
    required this.getProfileName,
    required this.onRegister,
    required this.onUnregister,
    required this.onDelete,
    required this.onEdit,
    required this.onProfileRequested,
  });
}

class EventFormArguments {
  final CampusEvent? event;
  const EventFormArguments({this.event});
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.detail:
      final args = settings.arguments;
      if (args is EventDetailArguments) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => EventDetailScreen(arguments: args),
        );
      }
      return _notFoundRoute(settings);
    case Routes.form:
      final args = settings.arguments;
      if (args is EventFormArguments) {
        return MaterialPageRoute<CampusEvent>(
          settings: settings,
          builder: (_) => EventFormScreen(event: args.event),
        );
      }
      return _notFoundRoute(settings);
    default:
      return _notFoundRoute(settings);
  }
}

Route<dynamic> _notFoundRoute(RouteSettings settings) {
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))),
  );
}
