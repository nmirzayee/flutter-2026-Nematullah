
import 'package:flutter/material.dart';
import 'students.dart';
import 'students_screen.dart';
import 'detail_screen.dart';
import 'edit_screen.dart';
import 'routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    initialRoute: Routes.students,
    routes: {
      Routes.students: (_) => const StudentsScreen(),
    },
    onGenerateRoute: (settings) {
      if (settings.name == Routes.student) {
        final student = settings.arguments as Student;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(student: student),
        );
      }
      if (settings.name == Routes.edit) {
        final student = settings.arguments as Student;
        return MaterialPageRoute(
          builder: (_) => EditScreen(student: student),
        );
      }
      return null;
    },
  );
}
