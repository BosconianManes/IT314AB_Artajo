import 'package:flutter/material.dart';
import 'profile_data.dart';
import 'student_details_screen.dart';
import 'add_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  int _tapCount = 0;

  void _deleteStudent(int index) async {
    // Optionally, you can add the DB delete logic here if you want the list to delete directly
    setState(() {
      students.removeAt(index);
    });
    saveStudents();
    debugPrint('Deleted student at index: $index');
  }

  Widget buildProfileCard({
    required String name,
    required String course,
    required int age,
    required String hobby,
    required String image,
    required String birthdate,
    required String studentId,
    required String email,
    required String favoriteSubject,
    required int index,
  }) {
    final student = students[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _tapCount++;
        });
        debugPrint('Card tapped: $name (Total taps: $_tapCount)');

        // FIXED: Changed from pushNamed to MaterialPageRoute
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetailsScreen(student: student),
          ),
        ).then((_) => setState(() {}));
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: student.isFavorite ? Colors.red : Colors.blue,
            width: student.isFavorite ? 3 : 2,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: student.isFavorite ? Colors.red[50] : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (student.isFavorite)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'FAVORITE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (student.isFavorite) const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: student.isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    student.isActive ? 'ACTIVE' : 'INACTIVE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (!student.isActive)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'This student is currently inactive',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 100),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: student.isFavorite ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  course,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: $studentId',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: $email',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Favorite Subject: $favoriteSubject',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hobby: $hobby',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Age: $age',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.purple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Birthdate: $birthdate',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.purple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            student.isFavorite = !student.isFavorite;
                          });
                          saveStudents();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: student.isFavorite
                              ? Colors.red
                              : Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              student.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(student.isFavorite ? 'Favorited' : 'Favorite'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentDetailsScreen(student: student),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 6),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      if (student.isActive) ...[
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Student'),
                                content: Text(
                                  'Are you sure you want to delete $name?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteStudent(index);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.delete, size: 18),
                              SizedBox(width: 6),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          appTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: students.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'No students found.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    buildProfileCard(
                      name: students[index].name,
                      course: students[index].course,
                      age: students[index].age,
                      hobby: students[index].hobby,
                      image: students[index].image,
                      birthdate: students[index].birthdate,
                      studentId: students[index].studentId,
                      email: students[index].email,
                      favoriteSubject: students[index].favoriteSubject,
                      index: index,
                    ),
                    if (index < students.length - 1) const SizedBox(height: 16),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudentScreen()),
          ).then((_) => setState(() {}));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
