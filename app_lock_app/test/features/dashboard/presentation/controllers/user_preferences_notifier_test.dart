import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_lock_app/core/data/database/database_helper.dart';
import 'package:app_lock_app/features/dashboard/data/repositories/focus_repository.dart';
import 'package:app_lock_app/features/dashboard/data/repositories/user_preferences_repository.dart';
import 'package:app_lock_app/features/dashboard/presentation/controllers/user_preferences_notifier.dart';

void main() {
  late UserPreferencesRepository userPrefsRepo;
  late FocusRepository focusRepo;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('user_preferences');
    await db.delete('focus_sessions');
    userPrefsRepo = UserPreferencesRepository();
    focusRepo = FocusRepository();
  });

  group('UserPreferencesNotifier', () {
    test('initial state has nulls before load', () {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      expect(notifier.isLoading, false);
      expect(notifier.error, isNull);
      expect(notifier.userName, isNull);
      expect(notifier.focusModeActive, isNull);
      expect(notifier.dailyGoalMinutes, isNull);
    });

    test('load fetches preferences from repository', () async {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      await notifier.load();
      expect(notifier.isLoading, false);
      expect(notifier.userName, 'Gustavo');
      expect(notifier.focusModeActive, true);
      expect(notifier.dailyGoalMinutes, 180);
    });

    test('toggleFocusMode toggles and persists', () async {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      await notifier.load();
      expect(notifier.focusModeActive, true);

      await notifier.toggleFocusMode();
      expect(notifier.focusModeActive, false);

      await notifier.toggleFocusMode();
      expect(notifier.focusModeActive, true);

      final prefs = await userPrefsRepo.getOrCreate();
      expect(prefs.focusModeActive, true);
    });

    test('toggleFocusMode records session when turning off', () async {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      await notifier.load();
      expect(notifier.focusModeActive, true);
      expect(await focusRepo.getTodayTotalSeconds(), 0);

      await notifier.toggleFocusMode();
      expect(notifier.focusModeActive, false);
      expect(notifier.error, isNull);

      await notifier.toggleFocusMode();
      expect(notifier.focusModeActive, true);
      expect(notifier.error, isNull);

      await Future.delayed(const Duration(seconds: 1));
      await notifier.toggleFocusMode();
      expect(notifier.focusModeActive, false);
      expect(notifier.error, isNull);

      final totalSeconds = await focusRepo.getTodayTotalSeconds();
      expect(totalSeconds, greaterThan(0));
    });

    test('toggleFocusMode does not insert session for zero elapsed', () async {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      await notifier.load();
      // Toggle ON and OFF rapidly - elapsed will be 0s
      await notifier.toggleFocusMode();
      await notifier.toggleFocusMode();

      final sessions = await focusRepo.getAll();
      expect(sessions.where((s) => s.durationSeconds == 0), isEmpty);
    });

    test('updateName persists new name', () async {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      await notifier.load();
      await notifier.updateName('Maria');
      expect(notifier.userName, 'Maria');

      final prefs = await userPrefsRepo.getOrCreate();
      expect(prefs.userName, 'Maria');
    });

    test('updateDailyGoal persists new goal', () async {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      await notifier.load();
      await notifier.updateDailyGoal(120);
      expect(notifier.dailyGoalMinutes, 120);

      final prefs = await userPrefsRepo.getOrCreate();
      expect(prefs.dailyGoalMinutes, 120);
    });

    test('isLoading is true during load', () async {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      final future = notifier.load();
      expect(notifier.isLoading, true);
      await future;
      expect(notifier.isLoading, false);
    });

    test('notifies listeners on toggle', () async {
      final notifier = UserPreferencesNotifier(
        repository: userPrefsRepo,
        focusRepository: focusRepo,
      );
      await notifier.load();
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);
      await notifier.toggleFocusMode();
      expect(notifyCount, greaterThan(0));
    });
  });
}
