import 'package:flutter/material.dart';

import 'data/seed_events.dart';
import 'models/campus_event.dart';
import 'models/profile.dart';
import 'routes/routes.dart';
import 'screens/events_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/profile_screen.dart';

class AppShell extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const AppShell({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late List<CampusEvent> _events;
  Profile _profile = const Profile.empty();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _events = createSeedEvents();
  }

  void _changeTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _toggleFavourite(CampusEvent event) {
    setState(() {
      _events = [
        for (final item in _events)
          if (item.id == event.id)
            item.copyWith(isFavourite: !item.isFavourite)
          else
            item,
      ];
    });
  }

  void _updateProfile(Profile profile) {
    setState(() => _profile = profile);
  }

  CampusEvent _getCurrentCampusEvent(String id) =>
      _events.firstWhere((event) => event.id == id);

  void _openCampusEvent(CampusEvent event) {
    Navigator.pushNamed<void>(
      context,
      Routes.detail,
      arguments: EventDetailArguments(
        event: event,
        getCurrentCampusEvent: _getCurrentCampusEvent,
        getProfileName: () => _profile.name.trim(),
        onRegister: _registerCampusEvent,
        onUnregister: _returnCampusEvent,
        onDelete: _deleteCampusEvent,
        onEdit: _editCampusEvent,
        onProfileRequested: () => _changeTab(2),
      ),
    );
  }

  void _registerCampusEvent(CampusEvent event) {
    final name = _profile.name.trim();
    if (name.isEmpty) return;
    setState(() {
      _events = [
        for (final item in _events)
          if (item.id == event.id && !item.isFull && !item.contains(name))
            item.copyWith(attendees: [...item.attendees, name])
          else
            item,
      ];
    });
  }

  void _returnCampusEvent(CampusEvent event) {
    final name = _profile.name.trim();
    if (name.isEmpty) return;
    setState(() {
      _events = [
        for (final item in _events)
          if (item.id == event.id && item.contains(name))
            item.copyWith(
              attendees: item.attendees
                  .where((attendee) => attendee != name)
                  .toList(),
            )
          else
            item,
      ];
    });
  }

  void _deleteCampusEvent(CampusEvent event) {
    setState(() {
      _events = [
        for (final item in _events)
          if (item.id != event.id) item,
      ];
    });
  }

  Future<void> _openEventForm([CampusEvent? existingCampusEvent]) async {
    final result = await Navigator.pushNamed<CampusEvent>(
      context,
      Routes.form,
      arguments: EventFormArguments(event: existingCampusEvent),
    );
    if (!mounted || result == null) return;

    setState(() {
      if (existingCampusEvent == null) {
        _events = [..._events, result];
      } else {
        _events = [
          for (final item in _events)
            if (item.id == existingCampusEvent.id) result else item,
        ];
      }
    });
  }

  void _addCampusEvent() {
    _openEventForm();
  }

  Future<void> _editCampusEvent(CampusEvent event) => _openEventForm(event);

  Future<void> _showAbout() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('About Campus Events'),
        content: const Text(
          'Browse events, manage registering, save favourites, '
          'and update your event profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset data?'),
        content: const Text('Restore original events and clear your profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() {
      _events = createSeedEvents();
      _profile = const Profile.empty();
      _selectedIndex = 0;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Data restored')));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      EventsScreen(
        events: _events,
        onFavourite: _toggleFavourite,
        onOpenCampusEvent: _openCampusEvent,
        onAddCampusEvent: _addCampusEvent,
      ),
      FavouritesScreen(
        events: _events,
        onFavourite: _toggleFavourite,
        onOpenCampusEvent: _openCampusEvent,
        onBrowseEvents: () => _changeTab(0),
      ),
      ProfileScreen(
        profile: _profile,
        events: _events,
        onProfileChanged: _updateProfile,
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Events')),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const ListTile(
                leading: Icon(Icons.event),
                title: Text('Campus Events'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  _showAbout();
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset Data'),
                onTap: () {
                  Navigator.pop(context);
                  _resetData();
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _addCampusEvent,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
