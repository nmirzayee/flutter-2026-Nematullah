
import 'package:flutter/material.dart';
import 'students.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late String _name = widget.student.name;

  bool _discardConfirmed = false;

  bool get _dirty => _name != widget.student.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
      ),
      body: PopScope(
        canPop: !_dirty || _discardConfirmed,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;

          final discard = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Discard changes?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: const Text('Keep editing'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text('Discard'),
                ),
              ],
            ),
          );

          if (discard == true && context.mounted) {
            setState(() {
              _discardConfirmed = true;
            });
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'New name',
                ),
                onChanged: (v) {
                  setState(() => _name = v);
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(_name);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
