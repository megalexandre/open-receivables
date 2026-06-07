import 'package:flutter/material.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

Future<bool> showConnectionDeleteDialog(
        BuildContext context, Connection connection) =>
    showAppDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Excluir ligação',
        content: Text(
          'Deseja excluir a ligação de "${connection.memberName}"?\nEsta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    ).then((v) => v ?? false);
