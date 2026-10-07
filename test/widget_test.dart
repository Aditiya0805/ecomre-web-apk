import 'package:flutter_test/flutter_test.dart';
import 'package:snack_distro/main.dart';

void main() {
  testWidgets('App loads successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('SnackDistro'), findsWidgets);
  });
}
