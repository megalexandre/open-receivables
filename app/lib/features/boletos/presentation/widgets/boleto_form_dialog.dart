import 'package:flutter/material.dart';
import 'package:organizagrana/features/boletos/domain/boleto.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

class BoletoFormDialog extends StatefulWidget {
  const BoletoFormDialog({super.key});

  static Future<Boleto?> show(BuildContext context) =>
      showAppDialog<Boleto>(
        context: context,
        builder: (_) => const BoletoFormDialog(),
      );

  @override
  State<BoletoFormDialog> createState() => _BoletoFormDialogState();
}

class _BoletoFormDialogState extends State<BoletoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _memberCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _competenciaCtrl = TextEditingController();
  final _vencimentoCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();

  @override
  void dispose() {
    _memberCtrl.dispose();
    _addressCtrl.dispose();
    _competenciaCtrl.dispose();
    _vencimentoCtrl.dispose();
    _valorCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(Boleto(
      id: '',
      number: '',
      memberName: _memberCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      competencia: _competenciaCtrl.text.trim(),
      valorTotal: double.tryParse(
              _valorCtrl.text.trim().replaceAll(',', '.')) ??
          0.0,
      vencimento: _vencimentoCtrl.text.trim(),
      status: BoletoStatus.aberta,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Novo Boleto',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Label('Sócio'),
            TextFormField(
              controller: _memberCtrl,
              decoration: const InputDecoration(
                hintText: 'Nome ou número do sócio',
                isDense: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            const _Label('Endereço'),
            TextFormField(
              controller: _addressCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex.: Rua das Flores, 123',
                isDense: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Label('Competência'),
                      TextFormField(
                        controller: _competenciaCtrl,
                        decoration: const InputDecoration(
                          hintText: 'MM/AAAA',
                          isDense: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Campo obrigatório'
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Label('Vencimento'),
                      TextFormField(
                        controller: _vencimentoCtrl,
                        decoration: const InputDecoration(
                          hintText: 'dd/MM/aaaa',
                          isDense: true,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Campo obrigatório'
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _Label('Valor Total (R\$)'),
            TextFormField(
              controller: _valorCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: '0,00',
                isDense: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
                final parsed =
                    double.tryParse(v.trim().replaceAll(',', '.'));
                if (parsed == null || parsed <= 0) {
                  return 'Valor inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.save_outlined, size: 16),
          label: const Text('Salvar'),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
