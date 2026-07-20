import 'package:flutter_test/flutter_test.dart';
import 'package:app_lock_app/features/dashboard/data/models/blocked_app_model.dart';

void main() {
  group('BlockedAppModel', () {
    test('toMap returns correct map', () {
      final model = BlockedAppModel(
        packageName: 'com.test.app',
        appName: 'Test App',
        iconCodePoint: 0xe3ff,
      );
      final map = model.toMap();
      expect(map['package_name'], 'com.test.app');
      expect(map['app_name'], 'Test App');
      expect(map['icon_code_point'], 0xe3ff);
      expect(map['is_blocked'], 1);
      expect(map['daily_limit_minutes'], 60);
      expect(map['time_used_today_seconds'], 0);
      expect(map.keys, contains('last_reset_date'));
      expect(map.keys, contains('created_at'));
    });

    test('fromMap reconstructs model correctly', () {
      final map = <String, dynamic>{
        'id': 1,
        'package_name': 'com.test.app',
        'app_name': 'Test App',
        'icon_code_point': 58960,
        'daily_limit_minutes': 60,
        'time_used_today_seconds': 1200,
        'last_reset_date': '2026-07-20',
        'is_blocked': 1,
        'created_at': '2026-07-20T10:00:00.000',
      };
      final model = BlockedAppModel.fromMap(map);
      expect(model.id, 1);
      expect(model.packageName, 'com.test.app');
      expect(model.appName, 'Test App');
      expect(model.iconCodePoint, 58960);
      expect(model.dailyLimitMinutes, 60);
      expect(model.timeUsedTodaySeconds, 1200);
      expect(model.lastResetDate, '2026-07-20');
      expect(model.isBlocked, true);
    });

    test('fromMap handles is_blocked = 0', () {
      final map = <String, dynamic>{
        'package_name': 'com.test.app',
        'app_name': 'Test App',
        'icon_code_point': 58960,
        'daily_limit_minutes': 30,
        'time_used_today_seconds': 1800,
        'last_reset_date': '2026-07-20',
        'is_blocked': 0,
        'created_at': '2026-07-20T10:00:00.000',
      };
      final model = BlockedAppModel.fromMap(map);
      expect(model.isBlocked, false);
    });

    test('copyWith creates independent copy', () {
      final original = BlockedAppModel(
        packageName: 'com.test.app',
        appName: 'Test App',
        iconCodePoint: 0xe3ff,
      );
      final modified = original.copyWith(appName: 'Changed');
      expect(original.appName, 'Test App');
      expect(modified.appName, 'Changed');
      expect(modified.packageName, 'com.test.app');
    });

    test('round-trip preserves data', () {
      final original = BlockedAppModel(
        id: 1,
        packageName: 'com.test.app',
        appName: 'Test App',
        iconCodePoint: 58960,
        dailyLimitMinutes: 90,
        timeUsedTodaySeconds: 600,
        isBlocked: true,
      );
      final map = original.toMap();
      final reconstructed = BlockedAppModel.fromMap(map);
      expect(reconstructed.packageName, original.packageName);
      expect(reconstructed.appName, original.appName);
      expect(reconstructed.iconCodePoint, original.iconCodePoint);
      expect(reconstructed.dailyLimitMinutes, original.dailyLimitMinutes);
      expect(reconstructed.timeUsedTodaySeconds, original.timeUsedTodaySeconds);
      expect(reconstructed.isBlocked, original.isBlocked);
    });

    test('lastResetDate defaults to today', () {
      final model = BlockedAppModel(
        packageName: 'com.test.app',
        appName: 'Test App',
        iconCodePoint: 0xe3ff,
      );
      final today = DateTime.now().toIso8601String().substring(0, 10);
      expect(model.lastResetDate, today);
    });
  });
}
