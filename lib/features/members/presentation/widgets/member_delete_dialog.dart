import 'package:flutter/material.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

Future<bool> showMemberDeleteDialog(BuildContext context, Member member) =>
    showAppDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Excluir sócio',
        content: Text('Deseja excluir "${member.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    ).then((v) => v ?? false);
