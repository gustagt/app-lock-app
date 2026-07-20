import 'package:flutter_test/flutter_test.dart';
import 'package:app_lock_app/main.dart';

void main() {
  testWidgets('App renders dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const AppLockApp());
    expect(find.text('Olá, Gustavo'), findsOneWidget);
  });
}
