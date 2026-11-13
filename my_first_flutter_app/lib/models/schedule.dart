class Schedule {
  final int? scheduleId;
  final int subjectId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final int slotCapacity;

  Schedule({
    this.scheduleId,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.slotCapacity,
  });

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      scheduleId: map['schedule_id'],
      subjectId: map['subject_id'] ?? 0,
      dayOfWeek: map['day_of_week'] ?? '',
      startTime: map['start_time'].toString(),
      endTime: map['end_time'].toString(),
      room: map['room'] ?? '',
      slotCapacity: map['slot_capacity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (scheduleId != null) 'schedule_id': scheduleId,
      'subject_id': subjectId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'slot_capacity': slotCapacity,
    };
  }
}
