import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const ColorScheme.light().primary),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const ColorScheme.light().primary,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      routes: {
        Routes.shell: (_) => AppShell(
          themeMode: _themeMode,
          onThemeChanged: _changeTheme,
        ),
      },
      onGenerateRoute: generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Not found')),
        ),
      ),
    );
  }
}
