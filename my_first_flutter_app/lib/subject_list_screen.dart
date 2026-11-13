import 'package:flutter/material.dart';
import 'models/subject.dart';
import 'repositories/subject_repository.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final SubjectRepository _repository = SubjectRepository();
  List<Subject> _subjects = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _repository.getAllSubjects();
      setState(() => _subjects = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteSubject(int id, int index) async {
    try {
      await _repository.deleteSubject(id);
      setState(() => _subjects.removeAt(index));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showSubjectDialog({Subject? subject}) {
    final codeController = TextEditingController(
      text: subject?.subjectCode ?? '',
    );
    final nameController = TextEditingController(
      text: subject?.subjectName ?? '',
    );
    final unitsController = TextEditingController(
      text: subject?.units.toString() ?? '',
    );
    final descController = TextEditingController(
      text: subject?.description ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(subject == null ? 'Add Subject' : 'Edit Subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Subject Code (e.g. IT101)',
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Subject Name'),
              ),
              TextField(
                controller: unitsController,
                decoration: const InputDecoration(labelText: 'Units'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
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
              final newSubject = Subject(
                subjectId: subject?.subjectId,
                subjectCode: codeController.text.trim(),
                subjectName: nameController.text.trim(),
                units: int.tryParse(unitsController.text.trim()) ?? 1,
                description: descController.text.trim(),
              );
              try {
                if (subject == null) {
                  await _repository.addSubject(newSubject);
                } else {
                  await _repository.updateSubject(newSubject);
                }
                if (ctx.mounted) Navigator.pop(ctx);
                _loadData();
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(
                    ctx,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: Text(subject == null ? 'Save' : 'Update'),
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
          'Subjects Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _subjects.isEmpty
          ? const Center(child: Text('No subjects found. Tap + to add.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        subject.subjectCode.isNotEmpty
                            ? subject.subjectCode.substring(0, 2)
                            : '??',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(
                      '${subject.subjectCode} - ${subject.subjectName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${subject.units} Units | ${subject.description ?? "No description"}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showSubjectDialog(subject: subject),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteSubject(subject.subjectId!, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSubjectDialog(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
