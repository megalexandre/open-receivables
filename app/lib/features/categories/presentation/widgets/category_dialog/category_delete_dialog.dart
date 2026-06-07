import 'package:flutter/material.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

Future<bool> showCategoryDeleteDialog(
  BuildContext context,
  Category category,
) async {
  final confirmed = await showAppDialog<bool>(
    context: context,
    builder: (_) => AppDialog(
      title: 'Excluir Categoria',
      content: Text(
        'Tem certeza que deseja excluir a categoria "${category.subCategoryName}/${category.name}"?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.delete_outline, size: 16),
          label: const Text('Excluir'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
