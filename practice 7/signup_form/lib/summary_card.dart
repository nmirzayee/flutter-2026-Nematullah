import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String name;
  final String email;
  final String group;
  final String birthDate;

  const SummaryCard({
    super.key,
    required this.name,
    required this.email,
    required this.group,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      ListTile(title: const Text('Name'), subtitle: Text(name)),
      ListTile(title: const Text('Email'), subtitle: Text(email)),
      ListTile(title: const Text('Group'), subtitle: Text(group)),
      ListTile(title: const Text('Date of birth'), subtitle: Text(birthDate)),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 4,
                children: tiles,
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: tiles,
            );
          },
        ),
      ),
    );
  }
}
