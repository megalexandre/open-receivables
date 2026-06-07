import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organizagrana/features/water_quality/domain/water_analysis.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

class WaterAnalysisFormDialog extends StatefulWidget {
  const WaterAnalysisFormDialog({super.key});

  static Future<WaterAnalysisBatch?> show(BuildContext context) =>
      showAppDialog<WaterAnalysisBatch>(
        context: context,
        builder: (_) => const WaterAnalysisFormDialog(),
      );

  @override
  State<WaterAnalysisFormDialog> createState() =>
      _WaterAnalysisFormDialogState();
}

class _WaterAnalysisFormDialogState extends State<WaterAnalysisFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final now = DateTime.now();
  late int _month = DateTime.now().month;
  late int _year = DateTime.now().year;

  // Controllers indexed by parameter index: [required, analyzed, conformity]
  late final List<List<TextEditingController>> _controllers =
      List.generate(kWaterParameters.length, (_) {
    return [
      TextEditingController(text: '0'),
      TextEditingController(text: '0'),
      TextEditingController(text: '0'),
    ];
  });

  static const _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  @override
  void dispose() {
    for (final row in _controllers) {
      for (final c in row) {
        c.dispose();
      }
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final entries = List.generate(kWaterParameters.length, (i) {
      return WaterAnalysisEntry(
        parameter: kWaterParameters[i],
        required_: double.parse(_controllers[i][0].text),
        analyzed: double.parse(_controllers[i][1].text),
        conformity: double.parse(_controllers[i][2].text),
      );
    });
    Navigator.of(context).pop(WaterAnalysisBatch(
      month: _month,
      year: _year,
      entries: entries,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final years = List.generate(5, (i) => now.year - i);

    return AppDialog(
      title: 'Adicionar Análise',
      width: 680,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Insira os resultados das medições de laboratório para o período.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Período de Referência:', style: theme.textTheme.labelMedium),
                const SizedBox(width: 12),
                SizedBox(
                  width: 140,
                  child: DropdownButtonFormField<int>(
                    initialValue: _month,
                    decoration: const InputDecoration(isDense: true),
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text(_months[i]),
                      ),
                    ),
                    onChanged: (v) => setState(() => _month = v!),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: DropdownButtonFormField<int>(
                    initialValue: _year,
                    decoration: const InputDecoration(isDense: true),
                    items: years
                        .map((y) => DropdownMenuItem(
                              value: y,
                              child: Text('$y'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _year = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const SizedBox(width: 160),
                  _HeaderCell('Exigido'),
                  _HeaderCell('Analisado'),
                  _HeaderCell('Conformidade'),
                ],
              ),
            ),
            ...List.generate(kWaterParameters.length, (i) {
              return _ParameterRow(
                parameter: kWaterParameters[i],
                controllers: _controllers[i],
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Salvar Análise'),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ParameterRow extends StatelessWidget {
  const _ParameterRow({
    required this.parameter,
    required this.controllers,
  });

  final String parameter;
  final List<TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    parameter,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          _NumField(controller: controllers[0]),
          _NumField(controller: controllers[1]),
          _NumField(controller: controllers[2]),
        ],
      ),
    );
  }
}

class _NumField extends StatelessWidget {
  const _NumField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: cs.surfaceContainerLow,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          validator: (v) =>
              (v == null || double.tryParse(v) == null) ? '' : null,
        ),
      ),
    );
  }
}
