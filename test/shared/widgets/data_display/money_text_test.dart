import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/shared/widgets/data_display/money_text.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('exibe o valor formatado como moeda', (tester) async {
    await tester.pumpWidget(_wrap(const MoneyText(53.00)));

    expect(find.textContaining('53,00'), findsOneWidget);
  });

  testWidgets('aceita TextStyle customizado', (tester) async {
    const style = TextStyle(fontSize: 20);
    await tester.pumpWidget(_wrap(const MoneyText(10.00, style: style)));

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.style?.fontSize, 20);
  });
}
