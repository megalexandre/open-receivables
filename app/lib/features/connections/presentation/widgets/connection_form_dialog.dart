import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/errors/app_failure.dart' show ValidationFailure;
import 'package:organizagrana/shared/widgets/form/category_dropdown.dart';
import 'package:organizagrana/shared/widgets/form/member_autocomplete.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

typedef ConnectionSaveCallback = Future<void> Function(Connection connection);

Future<bool> showConnectionFormDialog(
  BuildContext context, {
  Connection? connection,
  required MemberSearch searchMembers,
  required List<Address> addresses,
  required List<Category> categories,
  required ConnectionSaveCallback onSave,
}) async {
  final saved = await showAppDialog<bool>(
    context: context,
    builder: (_) => ConnectionFormDialog(
      connection: connection,
      searchMembers: searchMembers,
      addresses: addresses,
      categories: categories,
      onSave: onSave,
    ),
  );
  return saved ?? false;
}

class ConnectionFormDialog extends StatefulWidget {
  const ConnectionFormDialog({
    super.key,
    this.connection,
    required this.searchMembers,
    required this.addresses,
    required this.categories,
    required this.onSave,
  });

  final Connection? connection;
  final MemberSearch searchMembers;
  final List<Address> addresses;
  final List<Category> categories;
  final ConnectionSaveCallback onSave;

  @override
  State<ConnectionFormDialog> createState() => _ConnectionFormDialogState();
}

class _ConnectionFormDialogState extends State<ConnectionFormDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _memberId;
  String? _memberName;
  String? _addressId;
  String? _categoryId;
  late final TextEditingController _numeroCtrl;
  DateTime? _datamatricula;
  late bool _exclusiveMember;
  late bool _active;

  bool _saving = false;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    final c = widget.connection;
    _memberId = c?.memberId.isNotEmpty == true ? c!.memberId : null;
    _memberName = c?.memberName.isNotEmpty == true ? c!.memberName : null;
    _addressId = c?.addressId.isNotEmpty == true ? c!.addressId : null;
    _categoryId = c?.categoryId.isNotEmpty == true ? c!.categoryId : null;
    _numeroCtrl = TextEditingController(text: c?.numero ?? '');
    _datamatricula = c?.datamatricula;
    _exclusiveMember = c?.exclusiveMember ?? false;
    _active = c?.active ?? true;
  }

  @override
  void dispose() {
    _numeroCtrl.dispose();
    super.dispose();
  }

  Connection _buildConnection() => Connection(
        id: widget.connection?.id ?? '',
        memberId: _memberId ?? '',
        memberName: _memberName ?? '',
        addressId: _addressId ?? '',
        address: widget.addresses
                .where((a) => a.id == _addressId)
                .firstOrNull
                .let((a) => a != null ? '${a.addressType} ${a.name}' : '') ??
            '',
        active: _active,
        categoryId: _categoryId ?? '',
        categoryName: widget.categories
                .where((c) => c.id == _categoryId)
                .firstOrNull
                ?.name ??
            '',
        value: 0,
        numero: _numeroCtrl.text.trim().isNotEmpty ? _numeroCtrl.text.trim() : null,
        datamatricula: _datamatricula,
        exclusiveMember: _exclusiveMember,
      );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _datamatricula ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _datamatricula = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _apiError = null;
    });

    try {
      await widget.onSave(_buildConnection());
      if (mounted) Navigator.of(context).pop(true);
    } on ValidationFailure catch (e) {
      setState(() {
        _saving = false;
        _apiError = e.errors.map((err) => err.toString()).join('\n');
      });
    } catch (_) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEdit = widget.connection != null;

    return AppDialog(
      title: isEdit ? 'Editar Ligação' : 'Nova Ligação',
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
                  style: TextStyle(color: colorScheme.onErrorContainer, fontSize: 13),
                ),
              ),
              const SizedBox(height: 12),
            ],
            const _Label('Sócio'),
            MemberAutocomplete(
              search: widget.searchMembers,
              initialValue: _memberId != null
                  ? Member(
                      id: _memberId!,
                      name: _memberName ?? '',
                      document: '',
                    )
                  : null,
              onChanged: (m) => setState(() {
                _memberId = m?.id;
                _memberName = m?.name;
              }),
              validator: (m) => m == null ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            const _Label('Endereço'),
            DropdownButtonFormField<String>(
              initialValue: _addressId,
              decoration: const InputDecoration(isDense: true),
              isExpanded: true,
              items: widget.addresses
                  .map((a) => DropdownMenuItem(
                        value: a.id,
                        child: Text(
                          '${a.addressType} ${a.name}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _addressId = v),
              validator: (v) => v == null ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            const _Label('Categoria'),
            CategoryDropdown(
              categories: widget.categories,
              initialValue: _categoryId,
              onChanged: (v) => setState(() => _categoryId = v),
              validator: (v) => v == null ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            const _Label('Número'),
            TextFormField(
              controller: _numeroCtrl,
              decoration: const InputDecoration(isDense: true),
            ),
            const SizedBox(height: 12),
            const _Label('Data de matrícula'),
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
                    hintText: _datamatricula != null
                        ? '${_datamatricula!.day.toString().padLeft(2, '0')}/${_datamatricula!.month.toString().padLeft(2, '0')}/${_datamatricula!.year}'
                        : 'Selecionar data',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const _Label('Sócio exclusivo?'),
            DropdownButtonFormField<bool>(
              initialValue: _exclusiveMember,
              decoration: const InputDecoration(isDense: true),
              items: const [
                DropdownMenuItem(value: true, child: Text('Sim')),
                DropdownMenuItem(value: false, child: Text('Não')),
              ],
              onChanged: (v) => setState(() => _exclusiveMember = v!),
            ),
            if (isEdit) ...[
              const SizedBox(height: 12),
              const _Label('Ativo?'),
              DropdownButtonFormField<bool>(
                initialValue: _active,
                decoration: const InputDecoration(isDense: true),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Sim')),
                  DropdownMenuItem(value: false, child: Text('Não')),
                ],
                onChanged: (v) => setState(() => _active = v!),
              ),
            ],
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

extension _NullableExt<T> on T? {
  R? let<R>(R? Function(T?) f) => f(this);
}
