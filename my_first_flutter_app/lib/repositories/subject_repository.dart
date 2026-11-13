import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/subject.dart';

class SubjectRepository {
  Future<void> addSubject(Subject subject) async {
    final conn = await DbConnection.connection;
    await conn.execute(
      Sql.named('''
        INSERT INTO subjects (subject_code, subject_name, units, description)
        VALUES (@code, @name, @units, @desc)
      '''),
      parameters: {
        'code': subject.subjectCode,
        'name': subject.subjectName,
        'units': subject.units,
        'desc': subject.description,
      },
    );
  }

  Future<List<Subject>> getAllSubjects() async {
    final conn = await DbConnection.connection;
    final result = await conn.execute(
      'SELECT * FROM subjects ORDER BY subject_id',
    );
    return result.map((row) => Subject.fromMap(row.toColumnMap())).toList();
  }

  Future<void> updateSubject(Subject subject) async {
    final conn = await DbConnection.connection;
    await conn.execute(
      Sql.named('''
        UPDATE subjects 
        SET subject_code = @code, subject_name = @name, units = @units, description = @desc
        WHERE subject_id = @id
      '''),
      parameters: {
        'id': subject.subjectId,
        'code': subject.subjectCode,
        'name': subject.subjectName,
        'units': subject.units,
        'desc': subject.description,
      },
    );
  }

  Future<void> deleteSubject(int id) async {
    final conn = await DbConnection.connection;
    await conn.execute(
      Sql.named('DELETE FROM subjects WHERE subject_id = @id'),
      parameters: {'id': id},
    );
  }
}
