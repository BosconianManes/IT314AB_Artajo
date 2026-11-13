class Grade {
  final int? gradeId;
  final int enrollmentId;
  final double gradeValue;
  final String? remarks;

  // Extra fields for UI display
  final String? studentName;
  final String? subjectCode;

  Grade({
    this.gradeId,
    required this.enrollmentId,
    required this.gradeValue,
    this.remarks,
    this.studentName,
    this.subjectCode,
  });

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      gradeId: map['grade_id'],
      enrollmentId: map['enrollment_id'],
      gradeValue: (map['grade_value'] as num).toDouble(),
      remarks: map['remarks']?.toString(),
      studentName: map['student_name']?.toString(),
      subjectCode: map['subject_code']?.toString(),
    );
  }
}
