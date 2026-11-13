import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'profile_data.dart';
import 'student_list_screen.dart';
import 'subject_list_screen.dart';
import 'schedule_list_screen.dart';
import 'enrollment_list_screen.dart';
import 'grade_list_screen.dart'; // ADD THIS!

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await loadStudents();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const StudentListScreen(),
    const SubjectListScreen(),
    const ScheduleListScreen(),
    const EnrollmentListScreen(),
    const GradeListScreen(), // ADD THIS!
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed, // Keeps labels visible
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Subjects'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Enrollments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Grades',
          ), // ADD THIS!
        ],
      ),
    );
  }
}
