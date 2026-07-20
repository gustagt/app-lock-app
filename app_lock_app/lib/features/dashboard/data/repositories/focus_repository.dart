import '../../../../core/data/database/database_helper.dart';
import '../models/focus_session_model.dart';

class FocusRepository {
  final DatabaseHelper _dbHelper;

  FocusRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<FocusSessionModel>> getAll() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'focus_sessions',
      orderBy: 'created_at DESC',
    );
    return result.map((map) => FocusSessionModel.fromMap(map)).toList();
  }

  Future<List<FocusSessionModel>> getByDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final result = await db.query(
      'focus_sessions',
      where: 'date = ?',
      whereArgs: [dateStr],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => FocusSessionModel.fromMap(map)).toList();
  }

  Future<int> getTodayTotalSeconds() async {
    return getTotalSecondsForDate(DateTime.now());
  }

  Future<int> getTotalSecondsForDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(duration_seconds), 0) as total FROM focus_sessions WHERE date = ?',
      [dateStr],
    );
    return result.first['total'] as int;
  }

  Future<int> getYesterdayTotalSeconds() async {
    final yesterday =
        DateTime.now().subtract(const Duration(days: 1));
    return getTotalSecondsForDate(yesterday);
  }

  Future<double> getPercentageChange() async {
    final today = await getTodayTotalSeconds();
    final yesterday = await getYesterdayTotalSeconds();
    if (yesterday == 0) return today > 0 ? 100.0 : 0.0;
    return ((today - yesterday) / yesterday) * 100;
  }

  Future<int> insert(FocusSessionModel session) async {
    final db = await _dbHelper.database;
    return await db.insert('focus_sessions', session.toMap());
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'focus_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
