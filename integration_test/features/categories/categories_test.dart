import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> goToCategories(WidgetTester tester) async {
    await tester.tap(find.text('Categorias'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  group('Categorias', () {
    testWidgets('exibe a lista de categorias do servidor', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToCategories(tester);

      expect(find.textContaining('Exibindo'), findsOneWidget);
    });

    testWidgets('abre dialog de nova categoria', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToCategories(tester);

      await tester.tap(find.text('Nova Categoria'));
      await tester.pumpAndSettle();

      expect(find.text('Nova Categoria'), findsWidgets);
      expect(find.widgetWithText(TextFormField, 'Ex: Residencial A'), findsOneWidget);
    });

    testWidgets('valida campos obrigatórios no form', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToCategories(tester);

      await tester.tap(find.text('Nova Categoria'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsWidgets);
    });

    testWidgets('cria categoria e fecha o dialog', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToCategories(tester);

      await tester.tap(find.text('Nova Categoria'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ex: Residencial A'),
        'Teste',
      );
      // preenche os dois campos de valor (Valor Água e Valor Sócio)
      final valueFields = find.byType(TextFormField);
      await tester.enterText(valueFields.at(1), '10,00');
      await tester.enterText(valueFields.at(2), '5,00');

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // dialog fechou — campo do form não existe mais
      expect(find.widgetWithText(TextFormField, 'Ex: Residencial A'), findsNothing);
    });

    testWidgets('abre dialog de edição ao clicar em editar', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToCategories(tester);

      final editIcon = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(editIcon);
      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      expect(find.text('Editar Categoria'), findsOneWidget);
    });

    testWidgets('exibe dialog de confirmação ao excluir', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToCategories(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Excluir categoria'), findsOneWidget);
      expect(find.textContaining('Deseja excluir'), findsOneWidget);
    });

    testWidgets('confirmar exclusão fecha o dialog', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToCategories(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Excluir categoria'), findsNothing);
    });

    testWidgets('cancelar exclusão fecha o dialog sem excluir', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToCategories(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir categoria'), findsNothing);
      expect(find.textContaining('Exibindo'), findsOneWidget);
    });
  });
}
