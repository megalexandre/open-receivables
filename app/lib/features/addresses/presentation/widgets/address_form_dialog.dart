import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/shared/errors/api_error_code.dart';
import 'package:organizagrana/shared/errors/app_failure.dart'
    show AppFailure, ValidationFailure;
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

typedef AddressSaveCallback = Future<void> Function(Address address);

Future<bool> showAddressFormDialog(
  BuildContext context, {
  Address? address,
  required AddressSaveCallback onSave,
}) async {
  final saved = await showAppDialog<bool>(
    context: context,
    builder: (_) => AddressFormDialog(address: address, onSave: onSave),
  );
  return saved ?? false;
}

class AddressFormDialog extends StatefulWidget {
  const AddressFormDialog({super.key, this.address, required this.onSave});

  final Address? address;
  final AddressSaveCallback onSave;

  @override
  State<AddressFormDialog> createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late String _addressType;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _notesCtrl;

  bool _saving = false;
  String? _apiError;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _apiError = null;
    });

    final address = Address(
      id: widget.address?.id ?? '',
      addressType: _addressType,
      name: _nameCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    try {
      await widget.onSave(address);
      if (mounted) Navigator.of(context).pop(true);
    } on ValidationFailure catch (e) {
      final params = ApiErrorCode.paramsFromAddress(address);
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
    final colorScheme = Theme.of(context).colorScheme;
    final isEdit = widget.address != null;

    return AppDialog(
      title: isEdit ? 'Editar Endereço' : 'Novo Endereço',
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
                  color: colorScheme.errorContainer,
                  border: Border.all(color: colorScheme.error),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _apiError!,
                  style: TextStyle(
                    color: colorScheme.onErrorContainer,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
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
                          DropdownMenuItem(
                            value: 'Alameda',
                            child: Text('Alameda'),
                          ),
                          DropdownMenuItem(
                            value: 'Praça',
                            child: Text('Praça'),
                          ),
                          DropdownMenuItem(
                            value: 'Avenida',
                            child: Text('Avenida'),
                          ),
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
