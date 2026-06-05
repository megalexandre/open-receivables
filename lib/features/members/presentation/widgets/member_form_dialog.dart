import 'package:flutter/material.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

class MemberFormDialog extends StatefulWidget {
  const MemberFormDialog({super.key, this.member});

  final Member? member;

  static Future<Member?> show(BuildContext context, [Member? member]) =>
      showAppDialog<Member>(
        context: context,
        builder: (_) => MemberFormDialog(member: member),
      );

  @override
  State<MemberFormDialog> createState() => _MemberFormDialogState();
}

class _MemberFormDialogState extends State<MemberFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _documentCtrl;
  late final TextEditingController _memberNumberCtrl;

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    _nameCtrl = TextEditingController(text: m?.name ?? '');
    _documentCtrl = TextEditingController(text: m?.document ?? '');
    _memberNumberCtrl = TextEditingController(text: m?.memberNumber ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _documentCtrl.dispose();
    _memberNumberCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(Member(
      id: widget.member?.id ?? '',
      name: _nameCtrl.text.trim(),
      document: _documentCtrl.text.trim(),
      memberNumber: _memberNumberCtrl.text.trim(),
      active: widget.member?.active ?? true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.member != null;

    return AppDialog(
      title: isEdit ? 'Editar Sócio' : 'Novo Sócio',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
