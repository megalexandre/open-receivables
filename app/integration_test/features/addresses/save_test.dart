import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';
import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Logradouros — criação', () {
    testWidgets('abre dialog de novo endereço com os campos do form', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await tester.tap(find.text('Novo Endereço'));
      await tester.pumpAndSettle();

      expect(find.text('Novo Endereço'), findsWidgets);
      expect(find.text('Tipo'), findsWidgets);
      expect(find.widgetWithText(TextFormField, 'Digite o logradouro'), findsOneWidget);
      expect(find.text('Observações'), findsOneWidget);
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
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextFormField, 'Digite o logradouro'), findsNothing);
    });

    testWidgets('endereço duplicado exibe o erro da API e mantém o dialog aberto', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await tester.tap(find.text('Novo Endereço'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Digite o logradouro'),
        'Duplicada',
      );
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 422 E_ADDRESS_DUPLICATED → mensagem amigável e dialog aberto para correção.
      expect(
        find.text('O logradouro "Rua Duplicada" já está cadastrado'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextFormField, 'Digite o logradouro'), findsOneWidget);

      // Corrigindo o nome, o save passa e o dialog fecha.
      final nameField = find.widgetWithText(TextFormField, 'Duplicada');
      await tester.tap(nameField);
      await tester.pump();
      await tester.enterText(nameField, 'Corrigida');
      await tester.pump();
      expect(find.text('Corrigida'), findsOneWidget);
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextFormField, 'Digite o logradouro'), findsNothing);
    });
  });

  group('Logradouros — edição', () {
    testWidgets('abre dialog de edição com os dados do registro', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      final editIcon = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(editIcon);
      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      expect(find.text('Editar Endereço'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Santos'), findsOneWidget);
    });

    testWidgets('salva edição e fecha o dialog', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      final editIcon = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(editIcon);
      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Santos'),
        'Santos Editado',
      );
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Editar Endereço'), findsNothing);
    });
  });
}
