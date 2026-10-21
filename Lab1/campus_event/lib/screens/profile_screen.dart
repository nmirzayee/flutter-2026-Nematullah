import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;
  final List<CampusEvent> events;
  final ValueChanged<Profile> onProfileChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.events,
    required this.onProfileChanged,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _groupController;

  late final FocusNode _nameFocus;
  late final FocusNode _groupFocus;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profile.name);

    _groupController = TextEditingController(text: widget.profile.group);

    _nameFocus = FocusNode();
    _groupFocus = FocusNode();

    // Save the name when the user leaves the field.
    _nameFocus.addListener(_onNameFocusChanged);
    _groupFocus.addListener(_onGroupFocusChanged);
  }

  void _onNameFocusChanged() {
    if (!_nameFocus.hasFocus) {
      _saveName(_nameController.text);
    }
  }

  void _onGroupFocusChanged() {
    if (!_groupFocus.hasFocus) {
      _saveGroup(_groupController.text);
    }
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.profile.name != widget.profile.name && !_nameFocus.hasFocus) {
      _nameController.text = widget.profile.name;
    }

    if (oldWidget.profile.group != widget.profile.group &&
        !_groupFocus.hasFocus) {
      _groupController.text = widget.profile.group;
    }
  }

  // Save the user's name in the parent AppShell.
  void _saveName(String value) {
    final name = value.trim();

    // Avoid unnecessary updates.
    if (name == widget.profile.name) return;

    widget.onProfileChanged(widget.profile.copyWith(name: name));
  }

  // Validate and save the user's group.
  void _saveGroup(String value) {
    final group = value.trim();

    final validGroup = RegExp(r'^[A-Za-z0-9-]{2,20}$').hasMatch(group);

    if (!validGroup && group.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Group must be 2–20 letters, '
            'numbers or hyphens.',
          ),
        ),
      );
      return;
    }

    if (group == widget.profile.group) return;

    widget.onProfileChanged(widget.profile.copyWith(group: group));
  }

  @override
  void dispose() {
    _nameFocus.removeListener(_onNameFocusChanged);
    _groupFocus.removeListener(_onGroupFocusChanged);

    _nameController.dispose();
    _groupController.dispose();

    _nameFocus.dispose();
    _groupFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.profile.name.trim();

    // Calculate how many events the current user registered.
    final joinedCount = name.isEmpty
        ? 0
        : widget.events.where((event) => event.contains(name)).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        // Profile icon
        Icon(
          Icons.account_circle,
          size: 72,
          color: Theme.of(context).colorScheme.primary,
        ),

        const SizedBox(height: 16),

        // Name field
        TextField(
          controller: _nameController,
          focusNode: _nameFocus,
          decoration: const InputDecoration(
            labelText: 'Your name',
            hintText: 'Enter your name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {
            _saveName(value);
            _groupFocus.requestFocus();
          },
          onTapOutside: (_) {
            _nameFocus.unfocus();
          },
        ),

        const SizedBox(height: 16),

        // Group field
        TextField(
          controller: _groupController,
          focusNode: _groupFocus,
          decoration: const InputDecoration(
            labelText: 'Your group',
            hintText: 'SE-01',
            prefixIcon: Icon(Icons.groups_outlined),
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            _saveGroup(value);
            _groupFocus.unfocus();
          },
          onTapOutside: (_) {
            _groupFocus.unfocus();
          },
        ),

        const SizedBox(height: 20),

        // Profile summary
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(name.isEmpty ? 'No name saved' : name),
                subtitle: const Text('Event profile'),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.event),
                title: Text('You are on $joinedCount lists'),
                subtitle: const Text('Events you have registered'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Appearance settings
        Text('Appearance', style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('System'),
              selected: widget.themeMode == ThemeMode.system,
              onSelected: (_) {
                widget.onThemeChanged(ThemeMode.system);
              },
            ),

            ChoiceChip(
              label: const Text('Light'),
              selected: widget.themeMode == ThemeMode.light,
              onSelected: (_) {
                widget.onThemeChanged(ThemeMode.light);
              },
            ),

            ChoiceChip(
              label: const Text('Dark'),
              selected: widget.themeMode == ThemeMode.dark,
              onSelected: (_) {
                widget.onThemeChanged(ThemeMode.dark);
              },
            ),
          ],
        ),
      ],
    );
  }
}
