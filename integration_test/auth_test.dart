import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/app_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login', () {
    testWidgets('exibe tela de login quando não autenticado', (tester) async {
      await pumpUnauthenticated(tester);

      expect(find.widgetWithText(TextFormField, 'Usuário'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
    });

    testWidgets('valida campos vazios sem fazer requisição', (tester) async {
      await pumpUnauthenticated(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
      expect(find.text('Informe sua senha'), findsOneWidget);
    });

    testWidgets('login com sucesso redireciona para o home', (tester) async {
      await pumpUnauthenticated(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Usuário'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'senha123',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Após login bem-sucedido, o botão de login não aparece mais
      expect(find.widgetWithText(FilledButton, 'Entrar'), findsNothing);
    });

    testWidgets('credenciais inválidas exibem mensagem de erro', (tester) async {
      await pumpUnauthenticated(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Usuário'),
        'errado@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Senha'),
        'errada',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Credenciais invalidas.'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
    });
  });
}
