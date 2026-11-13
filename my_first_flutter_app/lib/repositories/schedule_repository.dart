import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  Future<void> addSchedule(Schedule schedule) async {
    final conn = await DbConnection.connection;
    await conn.execute(
      Sql.named('''
        INSERT INTO schedules (subject_id, day_of_week, start_time, end_time, room, slot_capacity)
        VALUES (@subject_id, @day, @start, @end, @room, @capacity)
      '''),
      parameters: {
        'subject_id': schedule.subjectId,
        'day': schedule.dayOfWeek,
        'start': schedule.startTime,
        'end': schedule.endTime,
        'room': schedule.room,
        'capacity': schedule.slotCapacity,
      },
    );
  }

  Future<List<Schedule>> getAllSchedules() async {
    final conn = await DbConnection.connection;
    final result = await conn.execute(
      'SELECT * FROM schedules ORDER BY schedule_id',
    );
    return result.map((row) => Schedule.fromMap(row.toColumnMap())).toList();
  }

  Future<void> deleteSchedule(int id) async {
    final conn = await DbConnection.connection;
    await conn.execute(
      Sql.named('DELETE FROM schedules WHERE schedule_id = @id'),
      parameters: {'id': id},
    );
  }
}
