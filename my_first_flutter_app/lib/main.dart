import 'package:flutter/material.dart';
import 'profile_data.dart';
import 'student_list_screen.dart';
import 'student_details_screen.dart';
import 'add_student_screen.dart';

void main() {
  students.sort((a, b) => a.name.compareTo(b.name));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) => const StudentListScreen(),
        '/student-details': (context) {
          final student = ModalRoute.of(context)!.settings.arguments as Student;
          return StudentDetailsScreen(student: student);
        },
        '/add-student': (context) => const AddStudentScreen(),
      },
    );
  }
}