import 'dart:async';

import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../models/countdown.dart';
import '../routes/routes.dart';
import '../utils/format.dart';
import '../widgets/empty_state.dart';

class EventDetailScreen extends StatefulWidget {
  final EventDetailArguments arguments;

  const EventDetailScreen({super.key, required this.arguments});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late CampusEvent _event;
  late final Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _event = widget.arguments.event;
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _refreshCampusEvent() {
    setState(() {
      _event = widget.arguments.getCurrentCampusEvent(_event.id);
    });
  }

  Future<void> _confirmRegister() async {
    final name = widget.arguments.getProfileName();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter your name in Profile first.'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () {
              widget.arguments.onProfileRequested();
              if (mounted) Navigator.pop(context);
            },
          ),
        ),
      );
      return;
    }

    final current = widget.arguments.getCurrentCampusEvent(_event.id);
    if (current.isFull || current.contains(name)) {
      _refreshCampusEvent();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Register event?'),
        content: Text('Do you want to register ${_event.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Register'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final latest = widget.arguments.getCurrentCampusEvent(_event.id);
    if (!latest.isFull && !latest.contains(name)) {
      widget.arguments.onRegister(latest);
    }
    _refreshCampusEvent();
  }

  Future<void> _confirmUnregister() async {
    final name = widget.arguments.getProfileName();
    if (name.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Unregister event?'),
        content: Text('Unregister ${_event.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Unregister'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final latest = widget.arguments.getCurrentCampusEvent(_event.id);
    if (latest.contains(name)) widget.arguments.onUnregister(latest);
    _refreshCampusEvent();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete event?'),
        content: Text('Delete ${_event.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    widget.arguments.onDelete(_event);
    Navigator.pop(context);
  }

  Future<void> _editCampusEvent() async {
    await widget.arguments.onEdit(_event);
    if (!mounted) return;
    _refreshCampusEvent();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (:taken, :free) = _event.places;
    final profileName = widget.arguments.getProfileName();
    final hasRegistered =
        profileName.isNotEmpty && _event.contains(profileName);
    final countdown = getCountdown(_event.startsAt, now: _now);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CampusEvent Details'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editCampusEvent();
                } else if (value == 'delete') {
                  _confirmDelete();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/event.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Chip(
                    avatar: Icon(_event.category.icon),
                    label: Text(_event.category.label),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Chip(label: Text(countdownLabel(countdown))),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _event.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$taken registered • $free available',
                    style: TextStyle(color: scheme.primary),
                  ),
                ],
              ),
            ),
            TabBar(
              tabs: [
                const Tab(text: 'About'),
                Tab(text: 'Attendees ($taken)'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(formatDate(_event.startsAt)),
                      ),
                      ListTile(
                        leading: Icon(
                          _event.isOnline ? Icons.language : Icons.location_on,
                        ),
                        title: Text(_event.place),
                      ),
                      if ((_event.description ?? '').isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(_event.description ?? ''),
                        ),
                    ],
                  ),
                  _event.attendees.isEmpty
                      ? const EmptyState(
                          icon: Icons.people_outline,
                          message: 'No attendees yet',
                        )
                      : ListView.builder(
                          itemCount: _event.attendees.length,
                          itemBuilder: (context, index) {
                            final name = _event.attendees[index];
                            final isYou =
                                profileName.isNotEmpty && name == profileName;
                            return ListTile(
                              leading: Icon(
                                isYou ? Icons.person_pin : Icons.person,
                              ),
                              title: Text(
                                isYou ? '$name (You)' : name,
                                style: TextStyle(
                                  fontWeight: isYou
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: hasRegistered
                      ? _confirmUnregister
                      : _event.isFull
                      ? null
                      : _confirmRegister,
                  child: Text(
                    hasRegistered
                        ? 'Unregister event'
                        : _event.isFull
                        ? 'No places available'
                        : 'Register event',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
