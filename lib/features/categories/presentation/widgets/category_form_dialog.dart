import 'package:flutter/material.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/shared/utils/currency_input_formatter.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

const _groups = ['Group A', 'Group B', 'Group C'];

class CategoryFormDialog extends StatefulWidget {
  const CategoryFormDialog({super.key, this.category});

  final Category? category;

  static Future<Category?> show(BuildContext context, [Category? category]) {
    return showAppDialog<Category>(
      context: context,
      builder: (_) => CategoryFormDialog(category: category),
    );
  }

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late String _group;
  late final TextEditingController _nameCtrl;
  late bool _waterMeter;
  late final TextEditingController _waterValueCtrl;
  late final TextEditingController _memberValueCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _group = c?.group ?? _groups.first;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _waterMeter = c?.waterMeter ?? true;
    _waterValueCtrl = TextEditingController(
      text: c != null ? c.waterValue.toStringAsFixed(2) : '',
    );
    _memberValueCtrl = TextEditingController(
      text: c != null ? c.memberValue.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _waterValueCtrl.dispose();
    _memberValueCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final waterValue = double.tryParse(
          _waterValueCtrl.text.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;
    final memberValue = double.tryParse(
          _memberValueCtrl.text.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;

    Navigator.of(context).pop(Category(
      id: widget.category?.id ?? '',
      name: _nameCtrl.text.trim(),
      group: _group,
      waterMeter: _waterMeter,
      waterValue: waterValue,
      memberValue: memberValue,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return AppDialog(
      title: isEdit ? 'Editar Categoria' : 'Nova Categoria',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Label('Grupo'),
            DropdownButtonFormField<String>(
              initialValue: _group,
              items: _groups
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _group = v!),
              decoration: const InputDecoration(isDense: true),
            ),
            const SizedBox(height: 12),
            const _Label('Nome'),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Ex: Residencial A',
                isDense: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            const _Label('Hidrômetro?'),
            DropdownButtonFormField<bool>(
              initialValue: _waterMeter,
              items: const [
                DropdownMenuItem(value: true, child: Text('Sim')),
                DropdownMenuItem(value: false, child: Text('Não')),
              ],
              onChanged: (v) => setState(() => _waterMeter = v!),
              decoration: const InputDecoration(isDense: true),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Label('Valor Água'),
                      TextFormField(
                        controller: _waterValueCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        decoration: const InputDecoration(
                          prefixText: 'R\$ ',
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
                      const _Label('Valor Sócio'),
                      TextFormField(
                        controller: _memberValueCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        decoration: const InputDecoration(
                          prefixText: 'R\$ ',
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
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
