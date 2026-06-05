import 'package:flutter/material.dart';
import 'package:organizagrana/shared/widgets/data_display/app_pagination.dart';

class AppTableColumn<T> {
  const AppTableColumn({
    required this.label,
    required this.builder,
    this.sortKey,
    this.numeric = false,
    this.showInCard = true,
  });

  final String label;
  final Widget Function(T item) builder;

  /// Quando definido, o header fica clicável e dispara [AppTable.onSort] com este valor.
  final String? sortKey;
  final bool numeric;
  final bool showInCard;
}

class AppTable<T> extends StatelessWidget {
  const AppTable({
    super.key,
    required this.columns,
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
    this.bordered = false,
    this.striped = false,
    this.breakpoint = 700,
  });

  final List<AppTableColumn<T>> columns;
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final void Function(int page) onPageChanged;

  /// Chamado ao clicar num header ordenável. Recebe a [sortKey] da coluna e a direção.
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;

  final bool loading;
  final bool bordered;
  final bool striped;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) =>
                      constraints.maxWidth >= breakpoint
                          ? _buildTable(context, constraints)
                          : _buildCards(context),
                ),
        ),
        const SizedBox(height: 12),
        AppPagination(
          total: total,
          page: page,
          pageSize: pageSize,
          onPageChanged: onPageChanged,
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context, BoxConstraints constraints) {
    final cs = Theme.of(context).colorScheme;

    final sortIndex = sortKey == null
        ? null
        : columns.indexWhere((c) => c.sortKey == sortKey);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: constraints.maxWidth),
        child: DataTable(
          showCheckboxColumn: false,
          sortColumnIndex: (sortIndex != null && sortIndex >= 0) ? sortIndex : null,
          sortAscending: sortAscending,
          headingRowColor: WidgetStateProperty.all(cs.surfaceContainerHighest),
          border: bordered
              ? TableBorder.all(color: cs.outlineVariant)
              : null,
          columns: columns.map((c) {
            return DataColumn(
              label: Text(c.label),
              numeric: c.numeric,
              onSort: c.sortKey != null && onSort != null
                  ? (_, ascending) => onSort!(c.sortKey!, ascending)
                  : null,
            );
          }).toList(),
          rows: items.indexed
              .map((entry) {
                final (index, item) = entry;
                final isOdd = index.isOdd;
                return DataRow(
                  onSelectChanged: (_) {},
                  color: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return cs.surfaceContainerLow;
                    }
                    if (striped) {
                      return isOdd ? cs.surfaceContainerLowest : cs.surface;
                    }
                    return Colors.transparent;
                  }),
                  cells: columns
                      .map((c) => DataCell(c.builder(item)))
                      .toList(),
                );
              })
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    final theme = Theme.of(context);
    final cardCols = columns.where((c) => c.showInCard).toList();
    return Column(
      children: items.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cardCols.map((c) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '${c.label}: ',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Expanded(child: c.builder(item)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}
