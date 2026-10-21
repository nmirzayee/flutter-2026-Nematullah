
import 'package:flutter/material.dart';
import 'students.dart';
import 'routes.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final s = students[index];

          return ListTile(
            leading: CircleAvatar(
              child: Text(s.name[0]),
            ),
            title: Text(s.name),
            subtitle: Text(s.group),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.student,
                arguments: s,
              );
            },
          );
        },
      ),
    );
  }
}
