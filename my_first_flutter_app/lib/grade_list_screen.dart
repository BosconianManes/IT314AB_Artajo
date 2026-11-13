import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'core/db_connection.dart';

class GradeListScreen extends StatefulWidget {
  const GradeListScreen({super.key});

  @override
  State<GradeListScreen> createState() => _GradeListScreenState();
}

class _GradeListScreenState extends State<GradeListScreen> {
  List<Map<String, dynamic>> _enrollmentsWithGrades = [];
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
        SELECT e.enrollment_id, 
               s.first_name || ' ' || s.last_name as student_name,
               sub.subject_code,
               g.grade_id, 
               g.grade_value, 
               g.remarks
        FROM enrollments e
        JOIN students s ON e.student_id = s.student_id
        JOIN subjects sub ON e.subject_id = sub.subject_id
        LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
        ORDER BY e.enrollment_id DESC
      ''');

      setState(() {
        _enrollmentsWithGrades = result
            .map((row) => row.toColumnMap())
            .toList();
      });
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showGradeDialog({
    required int enrollmentId,
    int? gradeId,
    double? currentValue,
  }) async {
    final valueController = TextEditingController(
      text: currentValue != null ? currentValue.toString() : '',
    );
    bool isEditing = gradeId != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Grade' : 'Add Grade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Grade Value (0 - 100)',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Note: 75.00 and above is 'Passed'. Below 75.00 is 'Failed'.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              double? gradeValue = double.tryParse(valueController.text.trim());
              if (gradeValue == null || gradeValue < 0 || gradeValue > 100) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid Grade Value (0-100)'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              String autoRemarks = gradeValue >= 75.0 ? 'Passed' : 'Failed';

              try {
                final conn = await DbConnection.connection;

                if (isEditing) {
                  await conn.execute(
                    Sql.named('''
                      UPDATE grades 
                      SET grade_value = @val, remarks = @rem 
                      WHERE grade_id = @gid
                    '''),
                    parameters: {
                      'val': gradeValue,
                      'rem': autoRemarks,
                      'gid': gradeId,
                    },
                  );
                } else {
                  await conn.execute(
                    Sql.named('''
                      INSERT INTO grades (enrollment_id, grade_value, remarks)
                      VALUES (@eid, @val, @rem)
                    '''),
                    parameters: {
                      'eid': enrollmentId,
                      'val': gradeValue,
                      'rem': autoRemarks,
                    },
                  );
                }

                if (ctx.mounted) Navigator.pop(ctx);
                _loadData();
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteGrade(int gradeId) async {
    try {
      final conn = await DbConnection.connection;
      await conn.execute(
        Sql.named('DELETE FROM grades WHERE grade_id = @id'),
        parameters: {'id': gradeId},
      );
      _loadData();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Grades Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _enrollmentsWithGrades.isEmpty
          ? const Center(
              child: Text('No enrollments found. Enroll a student first.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _enrollmentsWithGrades.length,
              itemBuilder: (context, index) {
                final row = _enrollmentsWithGrades[index];
                final bool hasGrade = row['grade_id'] != null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${row['student_name']} -> ${row['subject_code']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasGrade
                              ? 'Grade: ${row['grade_value']} | ${row['remarks'] ?? "No remarks"}'
                              : 'No grade assigned yet.',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),

                        // BUTTONS ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (hasGrade) ...[
                              ElevatedButton.icon(
                                onPressed: () => _showGradeDialog(
                                  enrollmentId: row['enrollment_id'],
                                  gradeId: row['grade_id'],
                                  // FIXED: Safely parse the grade value as a string first
                                  currentValue: double.tryParse(
                                    row['grade_value'].toString(),
                                  ),
                                ),
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Edit'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () => _deleteGrade(row['grade_id']),
                                icon: const Icon(Icons.delete, size: 18),
                                label: const Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ] else ...[
                              ElevatedButton.icon(
                                onPressed: () => _showGradeDialog(
                                  enrollmentId: row['enrollment_id'],
                                ),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Grade'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
