import 'package:flutter/material.dart';
import 'package:organizagrana/features/members/data/members_service.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/errors/api_error_code.dart';
import 'package:organizagrana/shared/utils/document_input_formatter.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

typedef MemberSaveCallback = Future<void> Function(Member member);

Future<bool> showMemberFormDialog(
  BuildContext context, {
  Member? member,
  required MemberSaveCallback onSave,
}) async {
  final saved = await showAppDialog<bool>(
    context: context,
    builder: (_) => MemberFormDialog(member: member, onSave: onSave),
  );
  return saved ?? false;
}

class MemberFormDialog extends StatefulWidget {
  const MemberFormDialog({super.key, this.member, required this.onSave});

  final Member? member;
  final MemberSaveCallback onSave;

  @override
  State<MemberFormDialog> createState() => _MemberFormDialogState();
}

class _MemberFormDialogState extends State<MemberFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _documentCtrl;
  late final TextEditingController _memberNumberCtrl;

  bool _voter = false;
  bool _saving = false;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _documentCtrl = TextEditingController(text: m?.document ?? '');
    _memberNumberCtrl = TextEditingController(text: m?.memberNumber?.toString() ?? '0');
    _voter = m?.voter ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _documentCtrl.dispose();
    _memberNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _apiError = null;
    });

    final member = Member(
      id: widget.member?.id ?? '',
      name: _nameCtrl.text.trim(),
      document: _documentCtrl.text.replaceAll(RegExp(r'\D'), ''),
      memberNumber: int.tryParse(_memberNumberCtrl.text.trim()),
      voter: _voter,
    );

    try {
      await widget.onSave(member);
      if (mounted) Navigator.of(context).pop(true);
    } on ValidationFailure catch (e) {
      final params = ApiErrorCode.paramsFromMember(member);
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
    final isEdit = widget.member != null;

    return AppDialog(
      title: isEdit ? 'Editar Sócio' : 'Novo Sócio',
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
            const _Label('Nome Completo'),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Digite o nome do sócio',
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
                      const _Label('Documento (CPF/CNPJ)'),
                      TextFormField(
                        controller: _documentCtrl,
                        decoration: const InputDecoration(
                          hintText: '000.000.000-00',
                          isDense: true,
                        ),
                        inputFormatters: [DocumentInputFormatter()],
                        validator: (v) {
                          final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                          if (digits.isEmpty) return 'Campo obrigatório';
                          if (digits.length < 11) return 'Mínimo 11 dígitos (CPF)';
                          if (digits.length > 14) return 'Máximo 14 dígitos (CNPJ)';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Label('Número de Sócio'),
                      TextFormField(
                        controller: _memberNumberCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Ex: 2024-001',
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
            const SizedBox(height: 4),
            SwitchListTile(
              value: _voter,
              onChanged: (v) => setState(() => _voter = v),
              title: const Text('É Votante'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
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
