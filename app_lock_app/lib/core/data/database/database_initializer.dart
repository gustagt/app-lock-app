import 'database_helper.dart';

class DatabaseInitializer {
  static Future<void> init() async {
    await DatabaseHelper.instance.database;
  }
}
