import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:app_lock_app/core/data/database/database_helper.dart';
import 'package:app_lock_app/features/dashboard/data/models/user_preferences_model.dart';
import 'package:app_lock_app/features/dashboard/data/repositories/user_preferences_repository.dart';

void main() {
  late UserPreferencesRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('user_preferences');
    repository = UserPreferencesRepository();
  });

  group('UserPreferencesRepository', () {
    test('getOrCreate returns default preferences on first call', () async {
      final prefs = await repository.getOrCreate();
      expect(prefs.userName, 'Gustavo');
      expect(prefs.focusModeActive, true);
      expect(prefs.dailyGoalMinutes, 180);
    });

    test('getOrCreate returns same preferences on second call', () async {
      await repository.getOrCreate();
      final prefs = await repository.getOrCreate();
      expect(prefs.userName, 'Gustavo');
    });

    test('save persists preferences', () async {
      await repository.getOrCreate();

      await repository.save(const UserPreferencesModel(
        userName: 'Maria',
        focusModeActive: false,
        dailyGoalMinutes: 60,
      ));

      final prefs = await repository.getOrCreate();
      expect(prefs.userName, 'Maria');
      expect(prefs.focusModeActive, false);
      expect(prefs.dailyGoalMinutes, 60);
    });

    test('save updates existing preferences', () async {
      await repository.getOrCreate();

      await repository.save(const UserPreferencesModel(
        userName: 'João',
        focusModeActive: true,
        dailyGoalMinutes: 120,
      ));

      final prefs = await repository.getOrCreate();
      expect(prefs.userName, 'João');
      expect(prefs.dailyGoalMinutes, 120);
    });

    test('getOrCreate only returns one row', () async {
      await repository.getOrCreate();
      await repository.getOrCreate();
      final db = await DatabaseHelper.instance.database;
      final result = await db.query('user_preferences');
      expect(result.length, 1);
    });
  });
}
