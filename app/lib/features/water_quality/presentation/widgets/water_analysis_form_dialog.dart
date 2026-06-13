import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organizagrana/features/water_quality/domain/water_analysis.dart';
import 'package:organizagrana/shared/errors/api_error_code.dart';
import 'package:organizagrana/shared/errors/app_failure.dart'
    show AppFailure, ValidationFailure;
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

typedef WaterAnalysisSaveCallback = Future<void> Function(
    WaterAnalysisBatch batch);

class WaterAnalysisFormDialog extends StatefulWidget {
  const WaterAnalysisFormDialog({super.key, required this.onSave});

  final WaterAnalysisSaveCallback onSave;

  static Future<bool> show(
    BuildContext context, {
    required WaterAnalysisSaveCallback onSave,
  }) async {
    final saved = await showAppDialog<bool>(
      context: context,
      builder: (_) => WaterAnalysisFormDialog(onSave: onSave),
    );
    return saved ?? false;
  }

  @override
  State<WaterAnalysisFormDialog> createState() =>
      _WaterAnalysisFormDialogState();
}

class _WaterAnalysisFormDialogState extends State<WaterAnalysisFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final now = DateTime.now();
  late int _month = DateTime.now().month;
  late int _year = DateTime.now().year;

  bool _saving = false;
  String? _apiError;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _apiError = null;
    });

    final entries = List.generate(kWaterParameters.length, (i) {
      return WaterAnalysisEntry(
        parameter: kWaterParameters[i],
        required_: double.parse(_controllers[i][0].text),
        analyzed: double.parse(_controllers[i][1].text),
        conformity: double.parse(_controllers[i][2].text),
      );
    });
    final batch = WaterAnalysisBatch(
      month: _month,
      year: _year,
      entries: entries,
    );

    try {
      await widget.onSave(batch);
      if (mounted) Navigator.of(context).pop(true);
    } on ValidationFailure catch (e) {
      final params = ApiErrorCode.paramsFromWaterBatch(batch);
      setState(() {
        _saving = false;
        _apiError = e.errors.map((err) => err.messageFor(params)).join('\n');
      });
    } on AppFailure catch (e) {
      setState(() {
        _saving = false;
        _apiError = e.message;
      });
    } catch (_) {
      if (mounted) Navigator.of(context).pop();
    }
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
            if (_apiError != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  border: Border.all(color: theme.colorScheme.error),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _apiError!,
                  style: TextStyle(
                    color: theme.colorScheme.onErrorContainer,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              'Insira os resultados das medições de laboratório para o período.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  child: Text('Período de Referência:', style: theme.textTheme.labelMedium),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<int>(
                    initialValue: _month,
                    isExpanded: true,
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
                  width: 100,
                  child: DropdownButtonFormField<int>(
                    initialValue: _year,
                    isExpanded: true,
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 160),
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
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _submit,
          icon: _saving
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined, size: 16),
          label: const Text('Salvar Análise'),
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
