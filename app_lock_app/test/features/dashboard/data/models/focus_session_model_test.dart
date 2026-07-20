import 'package:flutter_test/flutter_test.dart';
import 'package:app_lock_app/features/dashboard/data/models/focus_session_model.dart';

void main() {
  group('FocusSessionModel', () {
    test('toMap returns correct map', () {
      final model = FocusSessionModel(
        date: DateTime(2026, 7, 20),
        durationSeconds: 3600,
      );
      final map = model.toMap();
      expect(map['date'], '2026-07-20');
      expect(map['duration_seconds'], 3600);
      expect(map.keys, contains('created_at'));
    });

    test('fromMap reconstructs model correctly', () {
      final map = <String, dynamic>{
        'id': 1,
        'date': '2026-07-20',
        'duration_seconds': 7200,
        'created_at': '2026-07-20T10:00:00.000',
      };
      final model = FocusSessionModel.fromMap(map);
      expect(model.id, 1);
      expect(model.dateString, '2026-07-20');
      expect(model.durationSeconds, 7200);
    });

    test('copyWith creates independent copy', () {
      final original = FocusSessionModel(
        date: DateTime(2026, 7, 20),
        durationSeconds: 1800,
      );
      final modified = original.copyWith(durationSeconds: 3600);
      expect(original.durationSeconds, 1800);
      expect(modified.durationSeconds, 3600);
    });

    test('dateString formats correctly', () {
      final model = FocusSessionModel(
        date: DateTime(2026, 7, 20),
        durationSeconds: 0,
      );
      expect(model.dateString, '2026-07-20');
    });

    test('dateString pads months and days', () {
      final model = FocusSessionModel(
        date: DateTime(2026, 1, 5),
        durationSeconds: 0,
      );
      expect(model.dateString, '2026-01-05');
    });

    test('round-trip preserves data', () {
      final original = FocusSessionModel(
        id: 1,
        date: DateTime(2026, 7, 20),
        durationSeconds: 5400,
      );
      final map = original.toMap();
      final reconstructed = FocusSessionModel.fromMap(map);
      expect(reconstructed.id, original.id);
      expect(reconstructed.durationSeconds, original.durationSeconds);
      expect(reconstructed.dateString, original.dateString);
    });
  });
}
