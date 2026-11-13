import 'package:flutter/material.dart';
import 'models/schedule.dart';
import 'models/subject.dart';
import 'repositories/schedule_repository.dart';
import 'repositories/subject_repository.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  final ScheduleRepository _repository = ScheduleRepository();
  final SubjectRepository _subjectRepository = SubjectRepository();

  List<Schedule> _schedules = [];
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
      _subjects = await _subjectRepository.getAllSubjects();
      final data = await _repository.getAllSchedules();
      setState(() => _schedules = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteSchedule(int id, int index) async {
    try {
      await _repository.deleteSchedule(id);
      setState(() => _schedules.removeAt(index));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showAddScheduleDialog() {
    if (_subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a Subject first!')),
      );
      return;
    }

    int? selectedSubjectId = _subjects.first.subjectId;
    final dayController = TextEditingController(text: 'Monday');
    final startController = TextEditingController(text: '08:00:00');
    final endController = TextEditingController(text: '09:30:00');
    final roomController = TextEditingController(text: 'Room 101');
    final capacityController = TextEditingController(text: '30');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Schedule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: selectedSubjectId,
                decoration: const InputDecoration(labelText: 'Select Subject'),
                items: _subjects
                    .map(
                      (s) => DropdownMenuItem(
                        value: s.subjectId,
                        child: Text('${s.subjectCode} - ${s.subjectName}'),
                      ),
                    )
                    .toList(),
                onChanged: (val) => selectedSubjectId = val,
              ),
              TextField(
                controller: dayController,
                decoration: const InputDecoration(
                  labelText: 'Day (e.g. Monday)',
                ),
              ),
              TextField(
                controller: startController,
                decoration: const InputDecoration(
                  labelText: 'Start Time (HH:MM:SS)',
                ),
              ),
              TextField(
                controller: endController,
                decoration: const InputDecoration(
                  labelText: 'End Time (HH:MM:SS)',
                ),
              ),
              TextField(
                controller: roomController,
                decoration: const InputDecoration(labelText: 'Room'),
              ),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: 'Slot Capacity'),
                keyboardType: TextInputType.number,
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
              final newSchedule = Schedule(
                subjectId: selectedSubjectId!,
                dayOfWeek: dayController.text.trim(),
                startTime: startController.text.trim(),
                endTime: endController.text.trim(),
                room: roomController.text.trim(),
                slotCapacity:
                    int.tryParse(capacityController.text.trim()) ?? 30,
              );
              try {
                await _repository.addSchedule(newSchedule);
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
            child: const Text('Save'),
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
          'Schedule Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _schedules.isEmpty
          ? const Center(child: Text('No schedules found. Tap + to add.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      '${schedule.dayOfWeek} | ${schedule.startTime} - ${schedule.endTime}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Room: ${schedule.room} | Max Slots: ${schedule.slotCapacity}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _deleteSchedule(schedule.scheduleId!, index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
