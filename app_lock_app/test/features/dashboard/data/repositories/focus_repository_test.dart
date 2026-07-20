import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:app_lock_app/core/data/database/database_helper.dart';
import 'package:app_lock_app/features/dashboard/data/models/focus_session_model.dart';
import 'package:app_lock_app/features/dashboard/data/repositories/focus_repository.dart';

void main() {
  late FocusRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('focus_sessions');
    repository = FocusRepository();
  });

  group('FocusRepository', () {
    test('insert and getAll', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime(2026, 7, 20),
        durationSeconds: 1800,
      ));

      final sessions = await repository.getAll();
      expect(sessions.length, 1);
      expect(sessions.first.durationSeconds, 1800);
    });

    test('getByDate returns sessions for specific date', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime(2026, 7, 20),
        durationSeconds: 1200,
      ));
      await repository.insert(FocusSessionModel(
        date: DateTime(2026, 7, 21),
        durationSeconds: 2400,
      ));

      final sessions = await repository.getByDate(DateTime(2026, 7, 20));
      expect(sessions.length, 1);
      expect(sessions.first.durationSeconds, 1200);
    });

    test('getTotalSecondsForDate aggregates correctly', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime(2026, 7, 20),
        durationSeconds: 1800,
      ));
      await repository.insert(FocusSessionModel(
        date: DateTime(2026, 7, 20),
        durationSeconds: 900,
      ));

      final total = await repository.getTotalSecondsForDate(DateTime(2026, 7, 20));
      expect(total, 2700);
    });

    test('getTotalSecondsForDate returns 0 when no sessions', () async {
      final total = await repository.getTotalSecondsForDate(DateTime(2026, 1, 1));
      expect(total, 0);
    });

    test('getPercentageChange returns 0 when both days are empty', () async {
      final change = await repository.getPercentageChange();
      expect(change, 0.0);
    });

    test('delete removes session', () async {
      final id = await repository.insert(FocusSessionModel(
        date: DateTime(2026, 7, 20),
        durationSeconds: 600,
      ));

      await repository.delete(id);
      final sessions = await repository.getAll();
      expect(sessions.length, 0);
    });
  });
}
