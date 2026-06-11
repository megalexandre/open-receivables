import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> goToMembers(WidgetTester tester) async {
    await tester.tap(find.text('Sócios'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  group('Sócios', () {
    testWidgets('exibe a lista de sócios do servidor', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      expect(find.textContaining('Exibindo'), findsOneWidget);
    });

    testWidgets('abre dialog de novo sócio', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await tester.tap(find.text('Novo Sócio'));
      await tester.pumpAndSettle();

      expect(find.text('Novo Sócio'), findsWidgets);
      expect(find.widgetWithText(TextFormField, 'Digite o nome do sócio'), findsOneWidget);
    });

    testWidgets('valida campos obrigatórios no form', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await tester.tap(find.text('Novo Sócio'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsWidgets);
    });

    testWidgets('cria sócio e fecha o dialog', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await tester.tap(find.text('Novo Sócio'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'João Silva');
      await tester.enterText(fields.at(1), '000.000.000-00');
      await tester.enterText(fields.at(2), '2024-001');

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextFormField, 'Digite o nome do sócio'), findsNothing);
    });

    testWidgets('abre dialog de edição ao clicar em editar', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      final editIcon = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(editIcon);
      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      expect(find.text('Editar Sócio'), findsOneWidget);
    });

    testWidgets('exibe dialog de confirmação ao excluir', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Excluir sócio'), findsOneWidget);
      expect(find.textContaining('Deseja excluir'), findsOneWidget);
    });

    testWidgets('confirmar exclusão fecha o dialog', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Excluir sócio'), findsNothing);
    });

    testWidgets('cancelar exclusão fecha o dialog sem excluir', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir sócio'), findsNothing);
      expect(find.textContaining('Exibindo'), findsOneWidget);
    });
  });

  group('Sócios — inativos', () {
    Future<void> filterByInactive(WidgetTester tester) async {
      await tester.tap(find.byType(DropdownButtonFormField<bool>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inativos').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Consultar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    testWidgets('filtrar por inativos exibe os sócios deletados', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await filterByInactive(tester);

      expect(find.text('Sócio Desligado'), findsOneWidget);
      expect(find.text('Ricardo Mendonça'), findsNothing);
    });

    testWidgets('sócio inativo exibe reativar e visualizar, sem excluir',
        (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await filterByInactive(tester);

      expect(find.byIcon(Icons.restore), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('abrir sócio inativo exibe campos bloqueados e botão Reativar',
        (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await filterByInactive(tester);

      final editIcon = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(editIcon);
      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      expect(find.text('Reativar'), findsOneWidget);
      expect(find.text('Salvar'), findsNothing);
      expect(
        find.text('Sócio inativo. Reative para poder editar.'),
        findsOneWidget,
      );
    });

    testWidgets('Reativar no dialog fecha e refaz a consulta', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await filterByInactive(tester);

      final editIcon = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(editIcon);
      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reativar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Salvar'), findsNothing);
      expect(find.text('Reativar'), findsNothing);
      expect(find.textContaining('Exibindo'), findsOneWidget);
    });

    testWidgets('reativar refaz a consulta sem exibir erro', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await filterByInactive(tester);

      final restoreIcon = find.byIcon(Icons.restore).first;
      await tester.ensureVisible(restoreIcon);
      await tester.tap(restoreIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('Exibindo'), findsOneWidget);
      expect(find.text('Sócio não encontrado.'), findsNothing);
      expect(find.text('Falha no servidor.'), findsNothing);
    });

    testWidgets('limpar filtros restaura a lista de ativos', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToMembers(tester);

      await filterByInactive(tester);
      expect(find.text('Ricardo Mendonça'), findsNothing);

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Ricardo Mendonça'), findsOneWidget);
      expect(find.text('Sócio Desligado'), findsNothing);
    });
  });
}
