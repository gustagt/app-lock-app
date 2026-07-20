import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:app_lock_app/core/data/database/database_initializer.dart';
import 'package:app_lock_app/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App renders dashboard', (WidgetTester tester) async {
    await DatabaseInitializer.init();
    await tester.pumpWidget(const AppLockApp());
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Olá, Gustavo'), findsOneWidget);
  });
}
