import 'package:flutter/material.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

Future<bool> showCategoryDeleteDialog(BuildContext context, Category category) async {
  final confirmed = await showAppDialog<bool>(
    context: context,
    builder: (ctx) => AppDialog(
      title: 'Excluir categoria',
      content: Text('Deseja excluir "${category.name}"?'),
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
  );
  return confirmed == true;
}
