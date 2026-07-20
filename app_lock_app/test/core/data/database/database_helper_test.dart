import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:app_lock_app/core/data/database/database_helper.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  tearDown(() async {
    await DatabaseHelper.instance.close();
  });

  group('DatabaseHelper', () {
    test('database is instantiated successfully', () async {
      final db = await DatabaseHelper.instance.database;
      expect(db, isA<Database>());
      expect(db.isOpen, true);
    });

    test('creates blocked_apps table', () async {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='blocked_apps'",
      );
      expect(result.length, 1);
      expect(result.first['name'], 'blocked_apps');
    });

    test('creates focus_sessions table', () async {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='focus_sessions'",
      );
      expect(result.length, 1);
      expect(result.first['name'], 'focus_sessions');
    });

    test('creates user_preferences table', () async {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='user_preferences'",
      );
      expect(result.length, 1);
      expect(result.first['name'], 'user_preferences');
    });

    test('blocked_apps has expected columns', () async {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery('PRAGMA table_info(blocked_apps)');
      final columns = result.map((r) => r['name'] as String).toList();
      expect(columns, contains('id'));
      expect(columns, contains('package_name'));
      expect(columns, contains('app_name'));
      expect(columns, contains('icon_code_point'));
      expect(columns, contains('daily_limit_minutes'));
      expect(columns, contains('time_used_today_seconds'));
      expect(columns, contains('last_reset_date'));
      expect(columns, contains('is_blocked'));
      expect(columns, contains('created_at'));
      expect(columns, contains('updated_at'));
    });

    test('focus_sessions has expected columns', () async {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery('PRAGMA table_info(focus_sessions)');
      final columns = result.map((r) => r['name'] as String).toList();
      expect(columns, contains('id'));
      expect(columns, contains('date'));
      expect(columns, contains('duration_seconds'));
      expect(columns, contains('created_at'));
    });

    test('user_preferences has expected columns', () async {
      final db = await DatabaseHelper.instance.database;
      final result = await db.rawQuery('PRAGMA table_info(user_preferences)');
      final columns = result.map((r) => r['name'] as String).toList();
      expect(columns, contains('id'));
      expect(columns, contains('user_name'));
      expect(columns, contains('focus_mode_active'));
      expect(columns, contains('daily_goal_minutes'));
      expect(columns, contains('focus_session_started_at'));
      expect(columns, contains('updated_at'));
    });

    test('singleton returns same instance', () {
      expect(DatabaseHelper.instance, same(DatabaseHelper.instance));
    });
  });
}
