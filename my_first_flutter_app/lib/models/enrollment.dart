class Enrollment {
  final int? enrollmentId;
  final int studentId;
  final int subjectId;
  final int scheduleId;
  final String status;

  final String? studentName;
  final String? subjectCode;
  final String? dayOfWeek;
  final String? startTime;
  final String? endTime;

  Enrollment({
    this.enrollmentId,
    required this.studentId,
    required this.subjectId,
    required this.scheduleId,
    this.status = 'Enrolled',
    this.studentName,
    this.subjectCode,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
  });

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      enrollmentId: map['enrollment_id'],
      studentId: map['student_id'],
      subjectId: map['subject_id'],
      scheduleId: map['schedule_id'],
      status: map['status'] ?? 'Enrolled',
      studentName: map['student_name']?.toString(),
      subjectCode: map['subject_code']?.toString(),
      dayOfWeek: map['day_of_week']?.toString(),
      startTime: map['start_time']?.toString(),
      endTime: map['end_time']?.toString(),
    );
  }
}
