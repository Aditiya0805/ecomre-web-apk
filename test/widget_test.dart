import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snack_distro/data/models/user_model.dart';
import 'package:snack_distro/main.dart';
import 'package:snack_distro/presentation/screens/admin_login_screen.dart';

void main() {
  testWidgets('App loads successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('SnackDistro'), findsWidgets);
  });

  test('UserModel test parsing and admin role check', () {
    final user = UserModel.fromMap({
      'id': 1,
      'username': 'admin',
      'role': 'admin',
    });

    expect(user.id, 1);
    expect(user.username, 'admin');
    expect(user.isAdmin, true);
  });

  testWidgets('AdminLoginScreen renders properly with input fields and login button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AdminLoginScreen(),
      ),
    );

    expect(find.text('Login Admin'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Masuk'), findsOneWidget);
  });
}
