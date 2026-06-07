import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> goToAddresses(WidgetTester tester) async {
    await tester.tap(find.text('Logradouros'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  group('Logradouros', () {
    testWidgets('exibe a lista de logradouros do servidor', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      expect(find.textContaining('Exibindo'), findsOneWidget);
    });

    testWidgets('abre dialog de novo endereço', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await tester.tap(find.text('Novo Endereço'));
      await tester.pumpAndSettle();

      expect(find.text('Novo Endereço'), findsWidgets);
      expect(find.widgetWithText(TextFormField, 'Digite o logradouro'), findsOneWidget);
    });

    testWidgets('valida campos obrigatórios no form', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await tester.tap(find.text('Novo Endereço'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsWidgets);
    });

    testWidgets('cria endereço e fecha o dialog', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await tester.tap(find.text('Novo Endereço'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Digite o logradouro'),
        'Rua Teste',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, '00000-000'),
        '01310-100',
      );

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextFormField, 'Digite o logradouro'), findsNothing);
    });

    testWidgets('abre dialog de edição ao clicar em editar', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      final editIcon = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(editIcon);
      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      expect(find.text('Editar Endereço'), findsOneWidget);
    });

    testWidgets('exibe dialog de confirmação ao excluir', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Excluir endereço'), findsOneWidget);
      expect(find.textContaining('Deseja excluir'), findsOneWidget);
    });

    testWidgets('confirmar exclusão fecha o dialog', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Excluir endereço'), findsNothing);
    });

    testWidgets('cancelar exclusão fecha o dialog sem excluir', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir endereço'), findsNothing);
      expect(find.textContaining('Exibindo'), findsOneWidget);
    });
  });
}
