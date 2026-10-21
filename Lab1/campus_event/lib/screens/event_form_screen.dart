import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../models/event_category.dart';

class EventFormScreen extends StatefulWidget {
  final CampusEvent? event;

  const EventFormScreen({super.key, this.event});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _placeController;
  late final TextEditingController _limitController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;

  late final FocusNode _titleFocus;
  late final FocusNode _placeFocus;
  late final FocusNode _limitFocus;
  late final FocusNode _descriptionFocus;

  EventCategory? _category;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isOnline = false;
  bool _saving = false;
  bool _allowPop = false;
  late String _initialValues;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _titleController = TextEditingController(text: event?.title ?? '');
    _placeController = TextEditingController(text: event?.place ?? '');
    _limitController = TextEditingController(
      text: event?.capacity.toString() ?? '1',
    );
    _descriptionController = TextEditingController(
      text: event?.description ?? '',
    );
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _titleFocus = FocusNode();
    _placeFocus = FocusNode();
    _limitFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _category = event?.category;
    _isOnline = event?.isOnline ?? false;
    if (event != null) {
      _selectedDate = event.startsAt;
      _selectedTime = TimeOfDay.fromDateTime(event.startsAt);
      _updateDateFields();
    }
    _initialValues = _currentValues();
    for (final controller in [
      _titleController,
      _placeController,
      _limitController,
      _descriptionController,
    ]) {
      controller.addListener(_onFieldChanged);
    }
  }

  String _currentValues() => [
    _titleController.text,
    _placeController.text,
    _limitController.text,
    _descriptionController.text,
    _category?.name ?? '',
    _selectedDate?.toIso8601String() ?? '',
    _selectedTime?.hour.toString() ?? '',
    _selectedTime?.minute.toString() ?? '',
    _isOnline.toString(),
  ].join('|');

  bool get _isDirty => _currentValues() != _initialValues;

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  void _updateDateFields() {
    final date = _selectedDate;
    final time = _selectedTime;
    if (date != null) {
      _dateController.text = '${date.day}/${date.month}/${date.year}';
    }
    if (time != null) {
      _timeController.text =
          '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickDate() async {
    if (_saving) return;
    final today = DateTime.now();
    final initial = _selectedDate ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _updateDateFields();
      });
    }
  }

  Future<void> _pickTime() async {
    if (_saving) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _updateDateFields();
      });
    }
  }

  DateTime? get _startsAtTime {
    final date = _selectedDate;
    final time = _selectedTime;
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';
    if (title.length < 3) return 'Enter at least 3 characters';
    if (title.length > 60) return 'Maximum 60 characters';
    return null;
  }

  String? _validatePlace(String? value) {
    final place = value?.trim() ?? '';
    if (place.isEmpty)
      return _isOnline ? 'Enter an event link' : 'Enter a location';
    if (_isOnline && !place.contains('://')) {
      return 'Online link must contain ://';
    }
    return null;
  }

  String? _validateLimit(String? value) {
    final limit = int.tryParse(value?.trim() ?? '');
    if (limit == null || limit < 1 || limit > 500) {
      return 'Enter a whole number from 1 to 500';
    
    }
  //     if (_isOnline && limit > 100) {
  //   return 'Online events cannot exceed 100 places';
  // }

    final registered = widget.event?.count ?? 0;
    if (limit < registered) return 'Cannot be below $registered attendees';
    return null;
  }

  String? _validateEvent(String? value) {
    final event = _startsAtTime;
    if (event == null) return 'Select both date and time';
    if (!_isEditing && !event.isAfter(DateTime.now())) {
      return 'Event must be in the future';
    }
    return null;
  }

  Future<void> _save() async {
    if (_saving) return;
    // Safe: this method is called only while the Form is mounted.
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;
    final category = _category;
    final event = _startsAtTime;
    if (category == null || event == null) return;

    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final original = widget.event;
    final description = _descriptionController.text.trim();
    final savedCampusEvent = CampusEvent.safe(
      id: original?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: category,
      startsAt: event,
      place: _placeController.text.trim(),
      capacity: int.parse(_limitController.text.trim()),
      attendees: original?.attendees ?? const [],
      isOnline: _isOnline,
      description: description.isEmpty ? null : description,
      isFavourite: original?.isFavourite ?? false,
    );
    setState(() {
      _saving = false;
      _allowPop = true;
    });
    Navigator.pop(context, savedCampusEvent);
  }

  Future<void> _handlePop(bool didPop, CampusEvent? result) async {
    if (didPop || _saving) return;
    if (!_isDirty) {
      setState(() => _allowPop = true);
      Navigator.pop(context);
      return;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your unsaved changes will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (discard == true) {
      setState(() => _allowPop = true);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _limitController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _titleFocus.dispose();
    _placeFocus.dispose();
    _limitFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<CampusEvent>(
      canPop: _allowPop || (!_isDirty && !_saving),
      onPopInvokedWithResult: _handlePop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Event' : 'Add Event'),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              TextFormField(
                controller: _titleController,
                focusNode: _titleFocus,
                enabled: !_saving,
                maxLength: 60,
                decoration: const InputDecoration(
                  labelText: 'CampusEvent title',
                  border: OutlineInputBorder(),
                ),
                validator: _validateTitle,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _placeFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EventCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final category in EventCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(category.icon),
                          const SizedBox(width: 8),
                          Text(category.label),
                        ],
                      ),
                    ),
                ],
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _category = value),
                validator: (value) =>
                    value == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Online event'),
                subtitle: Text(
                  _isOnline
                      ? 'Enter an event link'
                      : 'Enter a physical location',
                ),
                value: _isOnline,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _isOnline = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _placeController,
                focusNode: _placeFocus,
                enabled: !_saving,
                decoration: InputDecoration(
                  labelText: _isOnline ? 'Event link' : 'Location',
                  border: const OutlineInputBorder(),
                ),
                validator: _validatePlace,
                keyboardType: _isOnline
                    ? TextInputType.url
                    : TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _limitFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _limitController,
                focusNode: _limitFocus,
                enabled: !_saving,
                decoration: const InputDecoration(
                  labelText: 'Event capacity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: _validateLimit,
                onFieldSubmitted: (_) => _descriptionFocus.requestFocus(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                enabled: !_saving,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Event date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: _validateEvent,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                enabled: !_saving,
                onTap: _pickTime,
                decoration: const InputDecoration(
                  labelText: 'Event time',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                validator: _validateEvent,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                focusNode: _descriptionFocus,
                enabled: !_saving,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : Text(_isEditing ? 'Save Changes' : 'Add Event'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
