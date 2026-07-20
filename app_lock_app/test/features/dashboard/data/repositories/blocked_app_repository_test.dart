import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:app_lock_app/core/data/database/database_helper.dart';
import 'package:app_lock_app/features/dashboard/data/models/blocked_app_model.dart';
import 'package:app_lock_app/features/dashboard/data/repositories/blocked_app_repository.dart';

void main() {
  late BlockedAppRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('blocked_apps');
    repository = BlockedAppRepository();
  });

  group('BlockedAppRepository', () {
    test('insert and getAll', () async {
      await repository.insert(BlockedAppModel(
        packageName: 'com.instagram.android',
        appName: 'Instagram',
        iconCodePoint: 0xe3ff,
      ));
      await repository.insert(BlockedAppModel(
        packageName: 'com.tiktok.android',
        appName: 'TikTok',
        iconCodePoint: 0xe4ff,
      ));

      final apps = await repository.getAll();
      expect(apps.length, 2);
      expect(apps.any((a) => a.packageName == 'com.instagram.android'), true);
      expect(apps.any((a) => a.packageName == 'com.tiktok.android'), true);
    });

    test('getById returns null for non-existent id', () async {
      final app = await repository.getById(999);
      expect(app, isNull);
    });

    test('getById returns correct app', () async {
      final id = await repository.insert(BlockedAppModel(
        packageName: 'com.youtube.android',
        appName: 'YouTube',
        iconCodePoint: 0xe5ff,
      ));

      final app = await repository.getById(id);
      expect(app, isNotNull);
      expect(app!.appName, 'YouTube');
      expect(app.packageName, 'com.youtube.android');
    });

    test('getByPackageName finds existing app', () async {
      await repository.insert(BlockedAppModel(
        packageName: 'com.spotify.android',
        appName: 'Spotify',
        iconCodePoint: 0xe6ff,
      ));

      final app = await repository.getByPackageName('com.spotify.android');
      expect(app, isNotNull);
      expect(app!.appName, 'Spotify');
    });

    test('getByPackageName returns null for non-existent', () async {
      final app = await repository.getByPackageName('com.nonexistent');
      expect(app, isNull);
    });

    test('getBlocked returns only blocked apps', () async {
      await repository.insert(BlockedAppModel(
        packageName: 'com.app1',
        appName: 'App 1',
        iconCodePoint: 1,
        isBlocked: true,
      ));
      await repository.insert(BlockedAppModel(
        packageName: 'com.app2',
        appName: 'App 2',
        iconCodePoint: 2,
        isBlocked: false,
      ));

      final blocked = await repository.getBlocked();
      expect(blocked.length, 1);
      expect(blocked.first.packageName, 'com.app1');
    });

    test('getBlockedCount returns correct count', () async {
      await repository.insert(BlockedAppModel(
        packageName: 'com.app1',
        appName: 'App 1',
        iconCodePoint: 1,
        isBlocked: true,
      ));
      await repository.insert(BlockedAppModel(
        packageName: 'com.app2',
        appName: 'App 2',
        iconCodePoint: 2,
        isBlocked: true,
      ));

      final count = await repository.getBlockedCount();
      expect(count, 2);
    });

    test('update modifies app fields', () async {
      final id = await repository.insert(BlockedAppModel(
        packageName: 'com.app',
        appName: 'Original',
        iconCodePoint: 123,
      ));

      final app = await repository.getById(id);
      await repository.update(app!.copyWith(appName: 'Updated'));

      final updated = await repository.getById(id);
      expect(updated!.appName, 'Updated');
    });

    test('delete removes app', () async {
      final id = await repository.insert(BlockedAppModel(
        packageName: 'com.app',
        appName: 'To Delete',
        iconCodePoint: 123,
      ));

      await repository.delete(id);
      final app = await repository.getById(id);
      expect(app, isNull);
    });

    test('resetDailyUsageIfNeeded resets time_used_today_seconds', () async {
      final id = await repository.insert(BlockedAppModel(
        packageName: 'com.app',
        appName: 'App',
        iconCodePoint: 123,
        timeUsedTodaySeconds: 3600,
        lastResetDate: '2000-01-01',
      ));

      await repository.resetDailyUsageIfNeeded();

      final app = await repository.getById(id);
      expect(app!.timeUsedTodaySeconds, 0);
    });

    test('resetDailyUsageIfNeeded does not reset today data', () async {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final id = await repository.insert(BlockedAppModel(
        packageName: 'com.app',
        appName: 'App',
        iconCodePoint: 123,
        timeUsedTodaySeconds: 3600,
        lastResetDate: today,
      ));

      await repository.resetDailyUsageIfNeeded();

      final app = await repository.getById(id);
      expect(app!.timeUsedTodaySeconds, 3600);
    });

    test('insert rejects duplicate package_name', () async {
      await repository.insert(BlockedAppModel(
        packageName: 'com.app',
        appName: 'First',
        iconCodePoint: 1,
      ));

      expect(
        () => repository.insert(BlockedAppModel(
          packageName: 'com.app',
          appName: 'Duplicate',
          iconCodePoint: 2,
        )),
        throwsA(isA<Exception>()),
      );
    });
  });
}
