import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> goToAddresses(WidgetTester tester) async {
  await tester.tap(find.text('Logradouros'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

Future<void> filterByName(WidgetTester tester, String name) async {
  await tester.enterText(
    find.widgetWithText(TextField, 'Buscar por nome...'),
    name,
  );
  await tester.tap(find.text('Consultar'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

Future<void> filterByType(WidgetTester tester, String type) async {
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(type).last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Consultar'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}
