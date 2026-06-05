import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/categories/presentation/widgets/category_delete_dialog.dart';

const _category = Category(
  id: '1',
  name: 'Água',
  group: 'A',
  waterMeter: false,
  waterValue: 0,
  memberValue: 0,
);

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('exibe o nome da categoria na mensagem', (tester) async {
    await tester.pumpWidget(_wrap(Builder(
      builder: (ctx) => TextButton(
        onPressed: () => showCategoryDeleteDialog(ctx, _category),
        child: const Text('abrir'),
      ),
    )));

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Água'), findsOneWidget);
  });

  testWidgets('retorna false ao cancelar', (tester) async {
    bool? result;

    await tester.pumpWidget(_wrap(Builder(
      builder: (ctx) => TextButton(
        onPressed: () async {
          result = await showCategoryDeleteDialog(ctx, _category);
        },
        child: const Text('abrir'),
      ),
    )));

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(result, false);
  });

  testWidgets('retorna true ao confirmar', (tester) async {
    bool? result;

    await tester.pumpWidget(_wrap(Builder(
      builder: (ctx) => TextButton(
        onPressed: () async {
          result = await showCategoryDeleteDialog(ctx, _category);
        },
        child: const Text('abrir'),
      ),
    )));

    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(result, true);
  });
}
