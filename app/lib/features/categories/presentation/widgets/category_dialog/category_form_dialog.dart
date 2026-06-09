import 'package:flutter/material.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/shared/errors/api_error_code.dart';
import 'package:organizagrana/shared/errors/app_failure.dart' show ValidationFailure;
import 'package:organizagrana/shared/utils/currency_input_formatter.dart';
import 'package:organizagrana/shared/widgets/form/subcategory_dropdown.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

typedef CategorySaveCallback = Future<void> Function(Category category);

Future<bool> showCategoryFormDialog(
  BuildContext context, {
  Category? category,
  required CategorySaveCallback onSave,
}) async {
  final saved = await showAppDialog<bool>(
    context: context,
    builder: (_) => CategoryFormDialog(category: category, onSave: onSave),
  );
  return saved ?? false;
}

class CategoryFormDialog extends StatefulWidget {
  const CategoryFormDialog({
    super.key,
    this.category,
    required this.onSave,
  });

  final Category? category;
  final CategorySaveCallback onSave;

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descricaoCtrl;
  String? _memberType;
  late bool _waterMeter;
  late final TextEditingController _waterValueCtrl;
  late final TextEditingController _memberValueCtrl;

  bool _saving = false;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _descricaoCtrl = TextEditingController(text: c?.descricao ?? '');
    _memberType = c?.memberType;
    _waterMeter = c?.waterMeter ?? false;
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
    _descricaoCtrl.dispose();
    _waterValueCtrl.dispose();
    _memberValueCtrl.dispose();
    super.dispose();
  }

  Category _buildCategory() => Category(
        id: widget.category?.id ?? '',
        name: _nameCtrl.text.trim(),
        descricao:
            _descricaoCtrl.text.trim().isEmpty ? null : _descricaoCtrl.text.trim(),
        memberType: _memberType,
        waterMeter: _waterMeter,
        waterValue: double.tryParse(
              _waterValueCtrl.text.replaceAll('.', '').replaceAll(',', '.'),
            ) ??
            0,
        memberValue: double.tryParse(
              _memberValueCtrl.text.replaceAll('.', '').replaceAll(',', '.'),
            ) ??
            0,
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _apiError = null;
    });

    final category = _buildCategory();

    try {
      await widget.onSave(category);
      if (mounted) Navigator.of(context).pop(true);
    } on ValidationFailure catch (e) {
      final params = ApiErrorCode.paramsFromCategory(category);
      setState(() {
        _saving = false;
        _apiError = e.errors.map((err) => err.messageFor(params)).join('\n');
      });
    } catch (_) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = widget.category == null ? 'Nova Categoria' : 'Editar Categoria';

    return AppDialog(
      title: title,
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
                      color: colorScheme.onErrorContainer, fontSize: 13),
                ),
              ),
              const SizedBox(height: 12),
            ],
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
            const _Label('Descrição'),
            TextFormField(
              controller: _descricaoCtrl,
              maxLines: 2,
              decoration: const InputDecoration(isDense: true),
            ),
            const SizedBox(height: 12),
            const _Label('Grupo'),
            SubcategoryDropdown(
              initialValue: _memberType,
              onChanged: (v) => setState(() => _memberType = v),
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
