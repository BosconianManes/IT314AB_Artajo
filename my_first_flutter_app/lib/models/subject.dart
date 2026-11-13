class Subject {
  final int? subjectId;
  final String subjectCode;
  final String subjectName;
  final int units;
  final String? description;

  Subject({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.units,
    this.description,
  });

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subjectId: map['subject_id'],
      subjectCode: map['subject_code'] ?? '',
      subjectName: map['subject_name'] ?? '',
      units: map['units'] ?? 0,
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (subjectId != null) 'subject_id': subjectId,
      'subject_code': subjectCode,
      'subject_name': subjectName,
      'units': units,
      'description': description,
    };
  }
}
