import 'package:flutter/material.dart';
import 'profile_data.dart';

void main() {
  students.sort((a, b) => a.name.compareTo(b.name));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _tapCount = 0;

  // DELETE METHOD
  void _deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
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
                // FAVORITE LABEL
                if (student.isFavorite)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
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
                const SizedBox(height: 8),
                Text(
                  'Card tapped: $_tapCount times',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // BUTTONS ROW
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // FAVORITE BUTTON
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            student.isFavorite = !student.isFavorite;
                          });
                          debugPrint('Favorite toggled for: $name (${student.isFavorite})');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: student.isFavorite ? Colors.red : Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              student.isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(student.isFavorite ? 'Favorited' : 'Favorite'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // EDIT BUTTON
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Edit Student'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Editing: $name',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Full edit screen coming in CTF 6!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    debugPrint('Edit confirmed for: $name');
                                  },
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit, size: 18),
                            const SizedBox(width: 6),
                            const Text('Edit'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      // DELETE BUTTON
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Student'),
                              content: Text('Are you sure you want to delete $name?'),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.delete, size: 18),
                            const SizedBox(width: 6),
                            const Text('Delete'),
                          ],
                        ),
                      ),
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
            Text(
              'No students found.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Student list is empty.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
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
    );
  }
}