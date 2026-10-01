import 'package:flutter/material.dart';

import 'profile_header.dart';
import 'data.dart';
import 'info_row.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('My profile')),
        body: Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ProfileHeader(name: myName, university: myUniversity),
                for (final fact in facts)
                  InfoRow(label: fact.label, value: fact.value),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
