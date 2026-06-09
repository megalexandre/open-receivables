import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

Future<bool> showAddressDeleteDialog(BuildContext context, Address address) =>
    showAppDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Excluir endereço',
        content: Text('Deseja excluir "${address.name}"?'),
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
