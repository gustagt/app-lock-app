import 'package:flutter_test/flutter_test.dart';
import 'package:app_lock_app/features/dashboard/data/models/user_preferences_model.dart';

void main() {
  group('UserPreferencesModel', () {
    test('uses default values', () {
      final model = const UserPreferencesModel();
      expect(model.userName, 'Gustavo');
      expect(model.focusModeActive, true);
      expect(model.dailyGoalMinutes, 180);
    });

    test('toMap returns correct map', () {
      final model = const UserPreferencesModel(
        userName: 'João',
        focusModeActive: false,
        dailyGoalMinutes: 120,
      );
      final map = model.toMap();
      expect(map['id'], 1);
      expect(map['user_name'], 'João');
      expect(map['focus_mode_active'], 0);
      expect(map['daily_goal_minutes'], 120);
    });

    test('fromMap reconstructs model correctly', () {
      final map = <String, dynamic>{
        'id': 1,
        'user_name': 'Maria',
        'focus_mode_active': 0,
        'daily_goal_minutes': 60,
      };
      final model = UserPreferencesModel.fromMap(map);
      expect(model.userName, 'Maria');
      expect(model.focusModeActive, false);
      expect(model.dailyGoalMinutes, 60);
    });

    test('fromMap handles active focus mode', () {
      final map = <String, dynamic>{
        'id': 1,
        'user_name': 'Gustavo',
        'focus_mode_active': 1,
        'daily_goal_minutes': 180,
      };
      final model = UserPreferencesModel.fromMap(map);
      expect(model.focusModeActive, true);
    });

    test('round-trip preserves data', () {
      final original = const UserPreferencesModel(
        userName: 'Ana',
        focusModeActive: true,
        dailyGoalMinutes: 90,
      );
      final map = original.toMap();
      final reconstructed = UserPreferencesModel.fromMap(map);
      expect(reconstructed.userName, original.userName);
      expect(reconstructed.focusModeActive, original.focusModeActive);
      expect(reconstructed.dailyGoalMinutes, original.dailyGoalMinutes);
    });

    test('copyWith creates independent copy', () {
      final original = const UserPreferencesModel();
      final modified = original.copyWith(userName: 'Pedro');
      expect(original.userName, 'Gustavo');
      expect(modified.userName, 'Pedro');
    });
  });
}
