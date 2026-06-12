import 'package:flutter/material.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';
import 'package:organizagrana/shared/widgets/data_display/money_text.dart';
import 'package:organizagrana/shared/widgets/data_display/subcategory_text.dart';
import 'package:organizagrana/shared/widgets/data_display/yes_no_badge.dart';

class CategoriesTable extends StatelessWidget {
  const CategoriesTable({
    super.key,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
    required this.onReactivate,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
    this.onLoadMore,
    this.hasMore = false,
    // mantidos para compatibilidade com modo paginado
    this.total = 0,
    this.page = 1,
    this.pageSize = 10,
    this.onPageChanged,
  });

  final List<Category> categories;
  final void Function(Category) onEdit;
  final void Function(Category) onDelete;
  final void Function(Category) onReactivate;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;
  final VoidCallback? onLoadMore;
  final bool hasMore;
  final int total;
  final int page;
  final int pageSize;
  final void Function(int page)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return AppTable<Category>(
      items: categories,
      total: total,
      page: page,
      pageSize: pageSize,
      onPageChanged: onPageChanged ?? (_) {},
      striped: true,
      onSort: onSort,
      sortKey: sortKey,
      sortAscending: sortAscending,
      loading: loading,
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      columns: [
        AppTableColumn(label: 'Nome', sortKey: 'name', flex: 3, builder: (c) => Text(c.name)),
        AppTableColumn(label: 'Grupo', sortKey: 'member_type', flex: 1.5, builder: (c) => SubcategoryText(value: c.memberType)),
        AppTableColumn(label: 'Hidrômetro', sortKey: 'has_hydrometer', builder: (c) => YesNoBadge(value: c.waterMeter)),
        AppTableColumn(label: 'Valor Água (R\$)', sortKey: 'amount_water', numeric: true, builder: (c) => MoneyText(c.waterValue)),
        AppTableColumn(label: 'Valor Sócio (R\$)', sortKey: 'amount_partner', numeric: true, builder: (c) => MoneyText(c.memberValue)),
        AppTableColumn(label: 'Total (R\$)', sortKey: 'total', numeric: true, builder: (c) => MoneyText(c.total)),
        AppTableColumn(
          label: 'Ações',
          showInCard: false,
          builder: (c) => Row(
            mainAxisSize: MainAxisSize.min,
            children: c.active
                ? [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Editar',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => onEdit(c),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      tooltip: 'Excluir',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => onDelete(c),
                    ),
                  ]
                : [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Visualizar',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => onEdit(c),
                    ),
                    IconButton(
                      icon: const Icon(Icons.restore, size: 18),
                      tooltip: 'Reativar',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => onReactivate(c),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}
