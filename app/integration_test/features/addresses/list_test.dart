import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fixtures.dart';
import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Logradouros — lista', () {
    testWidgets('exibe os logradouros do servidor', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      expect(find.text('Santos'), findsOneWidget);
      expect(find.text('das Flores'), findsOneWidget);
      expect(find.text('Brasil'), findsOneWidget);
      expect(find.text('Esperança'), findsOneWidget);
    });

    testWidgets('erro de servidor exibe mensagem na página', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await filterByName(tester, 'ERRO500');

      expect(find.text('Falha no servidor.'), findsOneWidget);
    });
  });

  group('Logradouros — filtros', () {
    testWidgets('filtrar por tipo exibe apenas o tipo escolhido', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await filterByType(tester, 'Avenida');

      expect(find.text('Brasil'), findsOneWidget);
      expect(find.text('Principal'), findsOneWidget);
      expect(find.text('Santos'), findsNothing);
      expect(find.text('das Flores'), findsNothing);
    });

    testWidgets('filtrar por nome exibe apenas o resultado da busca', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await filterByName(tester, 'Flores');

      expect(find.text('das Flores'), findsOneWidget);
      expect(find.text('Brasil'), findsNothing);
      expect(find.text('Santos'), findsNothing);
    });

    testWidgets('limpar filtros restaura a lista completa', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      await filterByType(tester, 'Avenida');
      expect(find.text('Santos'), findsNothing);

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Santos'), findsOneWidget);
      expect(find.text('das Flores'), findsOneWidget);
    });
  });

  group('Logradouros — ordenação', () {
    testWidgets('ordenar por nome refaz a consulta no servidor', (tester) async {
      await pumpAuthenticated(tester, fakeJwt());
      await goToAddresses(tester);

      // Ordem default (tipo, nome): Alameda Santos vem antes de Avenida Brasil.
      expect(
        tester.getTopLeft(find.text('Santos')).dy,
        lessThan(tester.getTopLeft(find.text('Brasil')).dy),
      );

      await tester.tap(find.text('Nome'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Ordenado por nome asc: Brasil passa a vir antes de Santos.
      expect(
        tester.getTopLeft(find.text('Brasil')).dy,
        lessThan(tester.getTopLeft(find.text('Santos')).dy),
      );
    });
  });
}
