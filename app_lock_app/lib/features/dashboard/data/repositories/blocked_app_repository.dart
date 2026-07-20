import '../../../../core/data/database/database_helper.dart';
import '../models/blocked_app_model.dart';

class BlockedAppRepository {
  final DatabaseHelper _dbHelper;

  BlockedAppRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<BlockedAppModel>> getAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('blocked_apps', orderBy: 'created_at DESC');
    return result.map((map) => BlockedAppModel.fromMap(map)).toList();
  }

  Future<List<BlockedAppModel>> getBlocked() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'blocked_apps',
      where: 'is_blocked = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => BlockedAppModel.fromMap(map)).toList();
  }

  Future<BlockedAppModel?> getById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'blocked_apps',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return BlockedAppModel.fromMap(result.first);
  }

  Future<BlockedAppModel?> getByPackageName(String packageName) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'blocked_apps',
      where: 'package_name = ?',
      whereArgs: [packageName],
    );
    if (result.isEmpty) return null;
    return BlockedAppModel.fromMap(result.first);
  }

  Future<int> getBlockedCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM blocked_apps WHERE is_blocked = 1',
    );
    return result.first['count'] as int;
  }

  Future<int> insert(BlockedAppModel app) async {
    final db = await _dbHelper.database;
    return await db.insert('blocked_apps', app.toMap());
  }

  Future<int> update(BlockedAppModel app) async {
    final db = await _dbHelper.database;
    return await db.update(
      'blocked_apps',
      app.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [app.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'blocked_apps',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> resetDailyUsageIfNeeded() async {
    final db = await _dbHelper.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await db.update(
      'blocked_apps',
      {
        'time_used_today_seconds': 0,
        'last_reset_date': today,
      },
      where: 'last_reset_date != ?',
      whereArgs: [today],
    );
  }
}
