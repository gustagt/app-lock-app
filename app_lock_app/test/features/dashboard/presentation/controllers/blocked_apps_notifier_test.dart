import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_lock_app/core/data/database/database_helper.dart';
import 'package:app_lock_app/features/dashboard/data/models/blocked_app_model.dart';
import 'package:app_lock_app/features/dashboard/data/repositories/blocked_app_repository.dart';
import 'package:app_lock_app/features/dashboard/presentation/controllers/blocked_apps_notifier.dart';

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

  group('BlockedAppsNotifier', () {
    test('initial state is empty', () {
      final notifier = BlockedAppsNotifier(repository: repository);
      expect(notifier.isLoading, false);
      expect(notifier.error, isNull);
      expect(notifier.blockedApps, isEmpty);
      expect(notifier.blockedCount, 0);
    });

    test('load fetches blocked apps', () async {
      await repository.insert(BlockedAppModel(
        packageName: 'com.instagram.android',
        appName: 'Instagram',
        iconCodePoint: 0xe3ff,
      ));
      await repository.insert(BlockedAppModel(
        packageName: 'com.tiktok.android',
        appName: 'TikTok',
        iconCodePoint: 0xe4ff,
        isBlocked: false,
      ));

      final notifier = BlockedAppsNotifier(repository: repository);
      await notifier.load();
      expect(notifier.blockedCount, 1);
      expect(notifier.blockedApps.first.appName, 'Instagram');
    });

    test('load returns all blocked apps', () async {
      await repository.insert(BlockedAppModel(
        packageName: 'com.app1',
        appName: 'App 1',
        iconCodePoint: 1,
      ));
      await repository.insert(BlockedAppModel(
        packageName: 'com.app2',
        appName: 'App 2',
        iconCodePoint: 2,
      ));

      final notifier = BlockedAppsNotifier(repository: repository);
      await notifier.load();
      expect(notifier.blockedCount, 2);
    });

    test('addApp inserts and updates list', () async {
      final notifier = BlockedAppsNotifier(repository: repository);
      await notifier.load();
      expect(notifier.blockedCount, 0);

      await notifier.addApp(BlockedAppModel(
        packageName: 'com.instagram.android',
        appName: 'Instagram',
        iconCodePoint: 0xe3ff,
      ));
      expect(notifier.blockedCount, 1);
    });

    test('addApp sets error on duplicate', () async {
      final notifier = BlockedAppsNotifier(repository: repository);
      await notifier.addApp(BlockedAppModel(
        packageName: 'com.instagram.android',
        appName: 'Instagram',
        iconCodePoint: 0xe3ff,
      ));
      expect(notifier.error, isNull);

      await notifier.addApp(BlockedAppModel(
        packageName: 'com.instagram.android',
        appName: 'Instagram',
        iconCodePoint: 0xe3ff,
      ));
      expect(notifier.error, isNotNull);
    });

    test('removeApp removes from list', () async {
      final notifier = BlockedAppsNotifier(repository: repository);
      await notifier.addApp(BlockedAppModel(
        packageName: 'com.instagram.android',
        appName: 'Instagram',
        iconCodePoint: 0xe3ff,
      ));
      expect(notifier.blockedCount, 1);

      final id = notifier.blockedApps.first.id!;
      await notifier.removeApp(id);
      expect(notifier.blockedCount, 0);
    });

    test('toggleBlock toggles isBlocked', () async {
      final notifier = BlockedAppsNotifier(repository: repository);
      await notifier.addApp(BlockedAppModel(
        packageName: 'com.instagram.android',
        appName: 'Instagram',
        iconCodePoint: 0xe3ff,
      ));
      expect(notifier.blockedApps.first.isBlocked, true);

      final id = notifier.blockedApps.first.id!;
      await notifier.toggleBlock(id);
      expect(notifier.blockedApps.first.isBlocked, false);

      await notifier.toggleBlock(id);
      expect(notifier.blockedApps.first.isBlocked, true);
    });

    test('isLoading is true during load', () async {
      final notifier = BlockedAppsNotifier(repository: repository);
      final future = notifier.load();
      expect(notifier.isLoading, true);
      await future;
      expect(notifier.isLoading, false);
    });

    test('notifies listeners on add', () async {
      final notifier = BlockedAppsNotifier(repository: repository);
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);
      await notifier.addApp(BlockedAppModel(
        packageName: 'com.instagram.android',
        appName: 'Instagram',
        iconCodePoint: 0xe3ff,
      ));
      expect(notifyCount, greaterThan(0));
    });
  });
}
