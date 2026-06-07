import 'package:flutter/material.dart';
import 'package:organizagrana/features/boletos/domain/boleto.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

Future<bool> showBoletoDeleteDialog(BuildContext context, Boleto boleto) =>
    showAppDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Excluir boleto',
        content: Text('Deseja excluir o boleto nº ${boleto.number}?'),
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
