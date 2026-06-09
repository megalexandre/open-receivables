import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

class AddressFormDialog extends StatefulWidget {
  const AddressFormDialog({super.key, this.address});

  final Address? address;

  static Future<Address?> show(BuildContext context, [Address? address]) =>
      showAppDialog<Address>(
        context: context,
        builder: (_) => AddressFormDialog(address: address),
      );

  @override
  State<AddressFormDialog> createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late String _addressType;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _addressType = a?.addressType ?? 'Rua';
    _nameCtrl = TextEditingController(text: a?.name ?? '');
    _notesCtrl = TextEditingController(text: a?.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(Address(
      id: widget.address?.id ?? '',
      addressType: _addressType,
      name: _nameCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;

    return AppDialog(
      title: isEdit ? 'Editar Endereço' : 'Novo Endereço',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Label('Tipo'),
                      DropdownButtonFormField<String>(
                        initialValue: _addressType,
                        items: const [
                          DropdownMenuItem(value: 'Rua', child: Text('Rua')),
                          DropdownMenuItem(value: 'Alameda', child: Text('Alameda')),
                          DropdownMenuItem(value: 'Praça', child: Text('Praça')),
                          DropdownMenuItem(value: 'Avenida', child: Text('Avenida')),
                        ],
                        onChanged: (v) => setState(() => _addressType = v!),
                        decoration: const InputDecoration(isDense: true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Label('Nome'),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Digite o logradouro',
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
            const _Label('Observações'),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Opcional',
                isDense: true,
              ),
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
