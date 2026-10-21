import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.buttonLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          // Safe: the collection if checks buttonLabel != null.
          if (buttonLabel != null && onPressed != null)
            TextButton(onPressed: onPressed, child: Text(buttonLabel!)),
        ],
      ),
    );
  }
}
