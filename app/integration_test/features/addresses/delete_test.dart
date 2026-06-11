import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';
import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Logradouros — exclusão', () {
    testWidgets('exibe dialog de confirmação com o nome do registro', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Excluir endereço'), findsOneWidget);
      expect(find.text('Deseja excluir "Santos"?'), findsOneWidget);
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

    testWidgets('cancelar exclusão fecha o dialog e mantém a lista', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      final deleteIcon = find.byIcon(Icons.delete_outline).first;
      await tester.ensureVisible(deleteIcon);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir endereço'), findsNothing);
      expect(find.text('Santos'), findsOneWidget);
    });
  });
}
