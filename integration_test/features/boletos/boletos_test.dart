import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> goToBoletos(WidgetTester tester) async {
    await tester.tap(find.text('Financeiro'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  group('Boletos', () {
    testWidgets('exibe a lista de boletos do servidor', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToBoletos(tester);

      expect(find.textContaining('Exibindo'), findsOneWidget);
    });

    testWidgets('exibe badge de status na listagem', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToBoletos(tester);

      expect(find.textContaining('Exibindo'), findsOneWidget);
      expect(find.text('Paga').first, findsOneWidget);
    });

    testWidgets('abre dialog de filtros e aciona consultar', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToBoletos(tester);

      await tester.tap(find.text('Consultar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('Exibindo'), findsOneWidget);
    });

    testWidgets('limpar filtros mantém a listagem', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToBoletos(tester);

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('Exibindo'), findsOneWidget);
    });

    testWidgets('abre dialog de novo boleto', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToBoletos(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Novo Boleto'), findsOneWidget);
    });

    testWidgets('valida campos obrigatórios no form', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToBoletos(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsWidgets);
    });

    testWidgets('exibe dialog de confirmação ao excluir', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToBoletos(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Excluir boleto'), findsOneWidget);
      expect(find.textContaining('Deseja excluir'), findsOneWidget);
    });

    testWidgets('cancelar exclusão fecha o dialog sem excluir', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToBoletos(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir boleto'), findsNothing);
      expect(find.textContaining('Exibindo'), findsOneWidget);
    });
  });
}
