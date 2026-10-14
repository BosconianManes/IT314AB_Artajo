import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Student {
  String name;
  String course;
  int age;
  String hobby;
  String image;
  String birthdate;
  String studentId;
  String email;
  String favoriteSubject;
  bool isFavorite;
  bool isActive;

  Student({
    required this.name,
    required this.course,
    required this.age,
    required this.hobby,
    required this.image,
    required this.birthdate,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
    this.isFavorite = false,
    this.isActive = true,
  });

  // turn a Student into a map (por saving)
  Map<String, dynamic> toJson() => {
    'name': name,
    'course': course,
    'age': age,
    'hobby': hobby,
    'image': image,
    'birthdate': birthdate,
    'studentId': studentId,
    'email': email,
    'favoriteSubject': favoriteSubject,
    'isFavorite': isFavorite,
    'isActive': isActive,
  };

  // turn a map back into a Student (for loading)
  factory Student.fromJson(Map<String, dynamic> json) => Student(
    name: json['name'],
    course: json['course'],
    age: json['age'],
    hobby: json['hobby'],
    image: json['image'],
    birthdate: json['birthdate'],
    studentId: json['studentId'],
    email: json['email'],
    favoriteSubject: json['favoriteSubject'],
    isFavorite: json['isFavorite'],
    isActive: json['isActive'],
  );
}

List<Student> students = [
  Student(
    name: 'Armanes Christopher G. Artajo',
    course: 'BSIT 3',
    age: 20,
    hobby: 'Playing Online Games',
    image: 'assets/profile.jpg',
    birthdate: 'Nov 16, 2005',
    studentId: '2024-001',
    email: 'armanes.artajo@edu.ph',
    favoriteSubject: 'IoT',
  ),
  Student(
    name: 'Ivan Villareal',
    course: 'BSIT 3',
    age: 19,
    hobby: 'VideoGrapher',
    image: 'assets/images.jpg',
    birthdate: 'Jan 31, 2002',
    studentId: '2024-002',
    email: 'ivan.villareal@edu.ph',
    favoriteSubject: 'IoT',
  ),
  Student(
    name: 'Wilken Nobetnov',
    course: 'BSIT 3',
    age: 21,
    hobby: 'Gooning',
    image: 'assets/wklen.jpg',
    birthdate: 'Mar 22, 2005',
    studentId: '2024-003',
    email: 'wilken.nobetnov@edu.ph',
    favoriteSubject: 'IoT',
    isActive: false,
  ),
  Student(
    name: 'Tonyo Moreno',
    course: 'BSIT 3',
    age: 18,
    hobby: 'Roblox',
    image: 'assets/toning.jpg',
    birthdate: 'Aug 4, 2005',
    studentId: '2024-004',
    email: 'tonyo.moreno@edu.ph',
    favoriteSubject: 'Project Management',
    isActive: false,
  ),
  Student(
    name: 'Joshua Santos',
    course: 'BSIT 3',
    age: 20,
    hobby: 'CODE',
    image: 'assets/shuaa.jpg',
    birthdate: 'Sep 3, 2005',
    studentId: '2024-005',
    email: 'joshua.santos@edu.ph',
    favoriteSubject: 'Project Management',
  ),
  Student(
    name: 'Vincent Rebese',
    course: 'BSIT 3',
    age: 21,
    hobby: 'Playing Online Games',
    image: 'assets/Binsoy.jpg',
    birthdate: 'Jan 5, 2005',
    studentId: '2024-006',
    email: 'vincent.rebese@edu.ph',
    favoriteSubject: 'Project Management',
  ),
];

String appTitle = 'Student Data';

// save the whole list
Future<void> saveStudents() async {
  final prefs = await SharedPreferences.getInstance();
  final data = students.map((s) => jsonEncode(s.toJson())).toList();
  await prefs.setStringList('students', data);
}

// load the saved list, if nothing is saved yet keep the default list
Future<void> loadStudents() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList('students');
  if (data == null) return;
  students = data.map((s) => Student.fromJson(jsonDecode(s))).toList();
}