import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/features/members/domain/member_failure.dart';
import 'package:organizagrana/features/members/presentation/widgets/member_form_dialog.dart';

const _activeMember = Member(
  id: '1',
  name: 'Ana Lima',
  document: '12345678901',
  memberNumber: 7,
);

const _inactiveMember = Member(
  id: '9',
  name: 'Sócio Desligado',
  document: '11122233344',
  memberNumber: 3,
  active: false,
);

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

Future<bool?> _open(
  WidgetTester tester, {
  Member? member,
  MemberSaveCallback? onSave,
  MemberSaveCallback? onReactivate,
}) async {
  bool? result;
  await tester.pumpWidget(_wrap(Builder(
    builder: (ctx) => TextButton(
      onPressed: () async {
        result = await showMemberFormDialog(
          ctx,
          member: member,
          onSave: onSave ?? (_) async {},
          onReactivate: onReactivate,
        );
      },
      child: const Text('abrir'),
    ),
  )));

  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
  return result;
}

void main() {
  group('sócio ativo', () {
    testWidgets('exibe botão Salvar e campos habilitados', (tester) async {
      await _open(tester, member: _activeMember);

      expect(find.text('Salvar'), findsOneWidget);
      expect(find.text('Reativar'), findsNothing);

      final fields = tester.widgetList<TextField>(find.byType(TextField));
      expect(fields.every((f) => f.enabled ?? true), isTrue);

      final voterSwitch =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(voterSwitch.onChanged, isNotNull);
    });
  });

  group('sócio inativo', () {
    testWidgets('exibe botão Reativar no lugar de Salvar', (tester) async {
      await _open(tester, member: _inactiveMember);

      expect(find.text('Reativar'), findsOneWidget);
      expect(find.text('Salvar'), findsNothing);
    });

    testWidgets('exibe aviso de sócio inativo', (tester) async {
      await _open(tester, member: _inactiveMember);

      expect(
        find.text('Sócio inativo. Reative para poder editar.'),
        findsOneWidget,
      );
    });

    testWidgets('todos os campos ficam bloqueados', (tester) async {
      await _open(tester, member: _inactiveMember);

      final fields = tester.widgetList<TextField>(find.byType(TextField));
      expect(fields, isNotEmpty);
      expect(fields.every((f) => f.enabled == false), isTrue);

      final voterSwitch =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(voterSwitch.onChanged, isNull);
    });

    testWidgets('Reativar chama onReactivate e fecha o dialog', (tester) async {
      Member? reactivated;
      bool? result;

      await tester.pumpWidget(_wrap(Builder(
        builder: (ctx) => TextButton(
          onPressed: () async {
            result = await showMemberFormDialog(
              ctx,
              member: _inactiveMember,
              onSave: (_) async {},
              onReactivate: (m) async => reactivated = m,
            );
          },
          child: const Text('abrir'),
        ),
      )));

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reativar'));
      await tester.pumpAndSettle();

      expect(reactivated?.id, '9');
      expect(result, true);
      expect(find.text('Reativar'), findsNothing);
    });

    testWidgets('falha na reativação exibe mensagem e mantém o dialog aberto',
        (tester) async {
      await _open(
        tester,
        member: _inactiveMember,
        onReactivate: (_) async =>
            throw const MemberFailure(AppFailureType.server),
      );

      await tester.tap(find.text('Reativar'));
      await tester.pumpAndSettle();

      expect(find.text('Reativar'), findsOneWidget);
      expect(find.text('Falha no servidor.'), findsOneWidget);
    });
  });
}
