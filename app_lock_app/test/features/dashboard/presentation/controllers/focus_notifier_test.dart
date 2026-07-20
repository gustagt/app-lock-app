import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_lock_app/core/data/database/database_helper.dart';
import 'package:app_lock_app/features/dashboard/data/models/focus_session_model.dart';
import 'package:app_lock_app/features/dashboard/data/repositories/focus_repository.dart';
import 'package:app_lock_app/features/dashboard/presentation/controllers/focus_notifier.dart';

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

  group('FocusNotifier', () {
    test('initial state has zeros', () {
      final notifier = FocusNotifier(repository: repository);
      expect(notifier.isLoading, false);
      expect(notifier.error, isNull);
      expect(notifier.todaySeconds, 0);
      expect(notifier.percentageChange, 0.0);
      expect(notifier.todayDurationFormatted, '0min');
      expect(notifier.percentageChangeFormatted, '0%');
    });

    test('load fetches data from repository', () async {
      final notifier = FocusNotifier(repository: repository);
      await notifier.load();
      expect(notifier.isLoading, false);
      expect(notifier.todaySeconds, 0);
    });

    test('loadSilently does not set isLoading', () async {
      final notifier = FocusNotifier(repository: repository);
      await notifier.loadSilently();
      expect(notifier.isLoading, false);
      expect(notifier.todaySeconds, 0);
    });

    test('load reflects inserted sessions', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime.now(),
        durationSeconds: 3600,
      ));

      final notifier = FocusNotifier(repository: repository);
      await notifier.load();
      expect(notifier.todaySeconds, 3600);
      expect(notifier.todayDurationFormatted, '1h 0min');
    });

    test('startActiveTracking adds elapsed time to todaySeconds', () async {
      final notifier = FocusNotifier(repository: repository);
      await notifier.load();

      final startedAt = DateTime.now().subtract(const Duration(seconds: 5));
      notifier.startActiveTracking(startedAt);

      expect(notifier.todaySeconds, greaterThanOrEqualTo(5));
      expect(notifier.todayDurationFormatted, contains('min'));

      notifier.stopActiveTracking();
    });

    test('stopActiveTracking resets to base value', () async {
      final notifier = FocusNotifier(repository: repository);
      await notifier.load();

      final startedAt = DateTime.now().subtract(const Duration(seconds: 5));
      notifier.startActiveTracking(startedAt);

      notifier.stopActiveTracking();
      expect(notifier.todaySeconds, 0);
    });

    test('startActiveTracking calls notifyListeners periodically', () async {
      final notifier = FocusNotifier(repository: repository);
      int callCount = 0;
      notifier.addListener(() => callCount++);

      final startedAt = DateTime.now();
      notifier.startActiveTracking(startedAt);

      await Future.delayed(const Duration(milliseconds: 1500));
      expect(callCount, greaterThanOrEqualTo(1));

      notifier.stopActiveTracking();
    });

    test('dispose cancels the active timer', () async {
      final notifier = FocusNotifier(repository: repository);
      final startedAt = DateTime.now().subtract(const Duration(seconds: 5));
      notifier.startActiveTracking(startedAt);

      notifier.dispose();

      await Future.delayed(const Duration(milliseconds: 1500));

      expect(notifier.todaySeconds, 0);
    });

    test('progress returns 0 when dailyGoalMinutes is null', () {
      final notifier = FocusNotifier(repository: repository);
      expect(notifier.progress(null), 0.0);
    });

    test('progress returns 0 when dailyGoalMinutes is 0', () {
      final notifier = FocusNotifier(repository: repository);
      expect(notifier.progress(0), 0.0);
    });

    test('progress returns correct value', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime.now(),
        durationSeconds: 1800,
      ));

      final notifier = FocusNotifier(repository: repository);
      await notifier.load();
      expect(notifier.progress(60), closeTo(0.5, 0.01));
    });

    test('progress clamps to 1.0', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime.now(),
        durationSeconds: 7200,
      ));

      final notifier = FocusNotifier(repository: repository);
      await notifier.load();
      expect(notifier.progress(60), 1.0);
    });

    test('metaLabel handles null dailyGoalMinutes', () {
      final notifier = FocusNotifier(repository: repository);
      expect(notifier.metaLabel(null), '0% da meta diária');
    });

    test('metaLabel formats correctly', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime.now(),
        durationSeconds: 900,
      ));

      final notifier = FocusNotifier(repository: repository);
      await notifier.load();
      expect(notifier.metaLabel(60), '25% da meta diária');
    });

    test('duration formatting via public API', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime.now(),
        durationSeconds: 3661,
      ));

      final notifier = FocusNotifier(repository: repository);
      await notifier.load();
      expect(notifier.todayDurationFormatted, '1h 1min');
    });

    test('duration formatting shows minutes when less than hour', () async {
      await repository.insert(FocusSessionModel(
        date: DateTime.now(),
        durationSeconds: 45,
      ));

      final notifier = FocusNotifier(repository: repository);
      await notifier.load();
      expect(notifier.todayDurationFormatted, '0min');
    });

    test('percentageChangeFormatted shows correct sign', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await repository.insert(FocusSessionModel(
        date: yesterday,
        durationSeconds: 1800,
      ));
      await repository.insert(FocusSessionModel(
        date: DateTime.now(),
        durationSeconds: 3600,
      ));

      final notifier = FocusNotifier(repository: repository);
      await notifier.load();
      expect(notifier.percentageChangeFormatted, '100%');
    });
  });
}
