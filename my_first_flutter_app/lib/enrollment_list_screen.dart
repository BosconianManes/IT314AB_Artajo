import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'core/db_connection.dart';

import 'models/enrollment.dart';
import 'models/subject.dart';
import 'models/schedule.dart';
import 'repositories/subject_repository.dart';
import 'repositories/schedule_repository.dart';
import 'profile_data.dart';

class EnrollmentListScreen extends StatefulWidget {
  const EnrollmentListScreen({super.key});

  @override
  State<EnrollmentListScreen> createState() => _EnrollmentListScreenState();
}

class _EnrollmentListScreenState extends State<EnrollmentListScreen> {
  final SubjectRepository _subRepo = SubjectRepository();
  final ScheduleRepository _schedRepo = ScheduleRepository();

  List<Enrollment> _enrollments = [];
  List<Subject> _subjects = [];
  List<Schedule> _schedules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final conn = await DbConnection.connection;

      final result = await conn.execute('''
        SELECT e.*, 
               s.first_name || ' ' || s.last_name as student_name,
               sub.subject_code,
               sch.day_of_week,
               sch.start_time,
               sch.end_time
        FROM enrollments e
        JOIN students s ON e.student_id = s.student_id
        JOIN subjects sub ON e.subject_id = sub.subject_id
        JOIN schedules sch ON e.schedule_id = sch.schedule_id
        ORDER BY e.enrollment_id DESC
      ''');

      final subs = await _subRepo.getAllSubjects();
      final scheds = await _schedRepo.getAllSchedules();

      setState(() {
        _enrollments = result
            .map((row) => Enrollment.fromMap(row.toColumnMap()))
            .toList();
        _subjects = subs;
        _schedules = scheds;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _dropEnrollment(int id) async {
    try {
      final conn = await DbConnection.connection;
      await conn.execute(
        Sql.named('DELETE FROM enrollments WHERE enrollment_id = @id'),
        parameters: {'id': id},
      );
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error dropping: $e')));
      }
    }
  }

  void _showEnrollDialog() {
    if (students.isEmpty || _subjects.isEmpty || _schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Need at least 1 Student, 1 Subject, and 1 Schedule.'),
        ),
      );
      return;
    }

    final studentController = TextEditingController(
      text: students.first.studentId,
    );
    int? selectedSubjectId = _subjects.first.subjectId;
    int? selectedScheduleId = _schedules.first.scheduleId;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enroll Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: studentController,
                decoration: const InputDecoration(
                  labelText: 'Student Number (e.g. 2024-002)',
                ),
              ),
              DropdownButtonFormField<int>(
                initialValue: selectedSubjectId,
                decoration: const InputDecoration(labelText: 'Subject'),
                items: _subjects
                    .map(
                      (s) => DropdownMenuItem(
                        value: s.subjectId,
                        child: Text(s.subjectCode),
                      ),
                    )
                    .toList(),
                onChanged: (v) => selectedSubjectId = v,
              ),
              DropdownButtonFormField<int>(
                initialValue: selectedScheduleId,
                decoration: const InputDecoration(labelText: 'Schedule'),
                items: _schedules
                    .map(
                      (s) => DropdownMenuItem(
                        value: s.scheduleId,
                        child: Text(
                          '${s.dayOfWeek} ${s.startTime} (Room ${s.room})',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => selectedScheduleId = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String studentNumber = studentController.text.trim();
              if (studentNumber.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a Student Number'),
                  ),
                );
                return;
              }

              try {
                final conn = await DbConnection.connection;

                final studentLookup = await conn.execute(
                  Sql.named(
                    'SELECT student_id FROM students WHERE student_number = @num',
                  ),
                  parameters: {'num': studentNumber},
                );

                if (studentLookup.isEmpty) {
                  if (ctx.mounted)
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text('Student Number not found in database!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  return;
                }

                int realDbStudentId = studentLookup.first[0] as int;

                // Rule 1: Check Duplicate
                final dupCheck = await conn.execute(
                  Sql.named(
                    'SELECT * FROM enrollments WHERE student_id = @sid AND subject_id = @subid',
                  ),
                  parameters: {
                    'sid': realDbStudentId,
                    'subid': selectedSubjectId,
                  },
                );
                if (dupCheck.isNotEmpty) {
                  if (ctx.mounted)
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Duplicate Error: Already enrolled in this subject.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  return;
                }

                // Fetch Schedule details for Conflict & Capacity Check
                final newScheduleResult = await conn.execute(
                  Sql.named(
                    'SELECT day_of_week, start_time, end_time, slot_capacity FROM schedules WHERE schedule_id = @id',
                  ),
                  parameters: {'id': selectedScheduleId},
                );
                final newSchedule = newScheduleResult.first.toColumnMap();
                String newDay = newSchedule['day_of_week'];

                // FIX: Clean the time format so Neon accepts it
                String rawStart = newSchedule['start_time'].toString();
                String rawEnd = newSchedule['end_time'].toString();
                String newStart = rawStart
                    .replaceAll('Time(', '')
                    .replaceAll(')', '');
                String newEnd = rawEnd
                    .replaceAll('Time(', '')
                    .replaceAll(')', '');

                int capacity = newSchedule['slot_capacity'];

                // Rule 2: Check Schedule Conflicts
                final conflictCheck = await conn.execute(
                  Sql.named('''
                    SELECT e.enrollment_id 
                    FROM enrollments e
                    JOIN schedules s ON e.schedule_id = s.schedule_id
                    WHERE e.student_id = @sid 
                      AND s.day_of_week = @day
                      AND (
                        (s.start_time <= @newStart AND s.end_time > @newStart) OR
                        (s.start_time < @newEnd AND s.end_time >= @newEnd) OR
                        (s.start_time >= @newStart AND s.end_time <= @newEnd)
                      )
                  '''),
                  parameters: {
                    'sid': realDbStudentId,
                    'day': newDay,
                    'newStart': newStart,
                    'newEnd': newEnd,
                  },
                );
                if (conflictCheck.isNotEmpty) {
                  if (ctx.mounted)
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Conflict Error: Schedule overlaps with an existing class.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  return;
                }

                // Rule 3: Check Slot Capacity
                final countCheck = await conn.execute(
                  Sql.named(
                    'SELECT COUNT(*) FROM enrollments WHERE schedule_id = @id AND status = \'Enrolled\'',
                  ),
                  parameters: {'id': selectedScheduleId},
                );
                int currentEnrolled = countCheck.first[0] as int;
                if (currentEnrolled >= capacity) {
                  if (ctx.mounted)
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Capacity Error: Schedule is full ($currentEnrolled/$capacity).',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  return;
                }

                // Rule 4: Insert
                await conn.execute(
                  Sql.named('''
                    INSERT INTO enrollments (student_id, subject_id, schedule_id, status)
                    VALUES (@sid, @subid, @schid, 'Enrolled')
                  '''),
                  parameters: {
                    'sid': realDbStudentId,
                    'subid': selectedSubjectId,
                    'schid': selectedScheduleId,
                  },
                );

                // Success!
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enrolled Successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _loadData();
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Database Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Enroll'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Enrollments',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _enrollments.isEmpty
          ? const Center(child: Text('No enrollments found. Tap + to add.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _enrollments.length,
              itemBuilder: (context, index) {
                final e = _enrollments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      '${e.studentName} -> ${e.subjectCode}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${e.dayOfWeek} | ${e.startTime} - ${e.endTime}\nStatus: ${e.status}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _dropEnrollment(e.enrollmentId!),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEnrollDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
