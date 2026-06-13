import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/water_quality/presentation/widgets/water_analysis_form_dialog.dart';
import 'package:organizagrana/shared/errors/api_error_code.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

Future<bool?> _open(
  WidgetTester tester, {
  WaterAnalysisSaveCallback? onSave,
}) async {
  bool? result;
  await tester.pumpWidget(_wrap(Builder(
    builder: (ctx) => TextButton(
      onPressed: () async {
        result = await WaterAnalysisFormDialog.show(
          ctx,
          onSave: onSave ?? (_) async {},
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
  testWidgets('salva com sucesso e fecha o dialog', (tester) async {
    var saved = false;
    await _open(tester, onSave: (_) async => saved = true);

    await tester.tap(find.text('Salvar Análise'));
    await tester.pumpAndSettle();

    expect(saved, isTrue);
    expect(find.text('Adicionar Análise'), findsNothing);
  });

  testWidgets('duplicação exibe mensagem clara e mantém o dialog aberto',
      (tester) async {
    await _open(
      tester,
      onSave: (_) async => throw const ValidationFailure([
        ApiValidationError(
          errorCode: ApiErrorCode.waterAnalysisDuplicated,
          field: 'parameter',
        ),
      ]),
    );

    await tester.tap(find.text('Salvar Análise'));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar Análise'), findsOneWidget);
    expect(
      find.textContaining(
          'Já existe uma análise de água cadastrada para a referência'),
      findsOneWidget,
    );
  });

  testWidgets('falha genérica exibe mensagem e mantém o dialog aberto',
      (tester) async {
    await _open(
      tester,
      onSave: (_) async => throw const AppFailure(AppFailureType.server),
    );

    await tester.tap(find.text('Salvar Análise'));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar Análise'), findsOneWidget);
    expect(find.text('Falha no servidor.'), findsOneWidget);
  });
}
