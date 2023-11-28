import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:week10_1109/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'drift_database.g.dart'; // 코드 생성 파일

@DriftDatabase(
    tables: [
      Schedules,
    ],
)

// drift 관련 쿼리를 작성할 클래스
class LocalDatabase extends _$LocalDatabase{ // Code Generation으로 생성할 클래스 상속
  LocalDatabase() : super(_openConnection());

  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });

}




