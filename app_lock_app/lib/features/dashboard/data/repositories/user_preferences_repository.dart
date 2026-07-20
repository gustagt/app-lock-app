import 'package:sqflite/sqflite.dart';

import '../../../../core/data/database/database_helper.dart';
import '../models/user_preferences_model.dart';

class UserPreferencesRepository {
  final DatabaseHelper _dbHelper;

  UserPreferencesRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<UserPreferencesModel> getOrCreate() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'user_preferences',
      where: 'id = 1',
    );
    if (result.isNotEmpty) {
      return UserPreferencesModel.fromMap(result.first);
    }
    final defaults = const UserPreferencesModel();
    await db.insert('user_preferences', defaults.toMap());
    return defaults;
  }

  Future<int> save(UserPreferencesModel prefs) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'user_preferences',
      prefs.copyWith(updatedAt: DateTime.now()).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
