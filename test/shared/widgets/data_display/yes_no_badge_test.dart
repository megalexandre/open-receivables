import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/app/app_theme.dart';
import 'package:organizagrana/shared/widgets/data_display/yes_no_badge.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('exibe "Sim" com cor secondary quando value é true', (tester) async {
    await tester.pumpWidget(_wrap(const YesNoBadge(value: true)));

    expect(find.text('Sim'), findsOneWidget);
  });

  testWidgets('exibe "Não" com cor onSurfaceVariant quando value é false', (tester) async {
    await tester.pumpWidget(_wrap(const YesNoBadge(value: false)));

    expect(find.text('Não'), findsOneWidget);
  });
}
