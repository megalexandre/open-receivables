import 'package:flutter/material.dart';
import 'package:organizagrana/shared/widgets/data_display/app_pagination.dart';
import 'package:pluto_grid/pluto_grid.dart';

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
                  builder: (context, constraints) => constraints.maxWidth >= breakpoint
                      ? _buildTable(context)
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

  String _fieldFor(AppTableColumn<T> col) => col.sortKey ?? col.label;

  Widget _buildTable(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final plutoColumns = <PlutoColumn>[
      // coluna oculta para carregar o índice do item
      PlutoColumn(
        title: '',
        field: '__idx',
        type: PlutoColumnType.number(),
        hide: true,
        enableSorting: false,
        enableColumnDrag: false,
        enableContextMenu: false,
        enableDropToResize: false,
      ),
      ...columns.map((col) => PlutoColumn(
            title: col.label,
            field: _fieldFor(col),
            type: PlutoColumnType.text(),
            textAlign: col.numeric ? PlutoColumnTextAlign.right : PlutoColumnTextAlign.left,
            titleTextAlign: col.numeric ? PlutoColumnTextAlign.right : PlutoColumnTextAlign.left,
            enableSorting: col.sortKey != null && onSort != null,
            enableColumnDrag: false,
            enableContextMenu: false,
            renderer: (rendererContext) {
              final idx = rendererContext.row.cells['__idx']!.value as int;
              return col.builder(items[idx]);
            },
          )),
    ];

    final plutoRows = items.indexed.map((entry) {
      final (i, _) = entry;
      return PlutoRow(cells: {
        '__idx': PlutoCell(value: i),
        for (final col in columns) _fieldFor(col): PlutoCell(value: ''),
      });
    }).toList();

    return PlutoGrid(
      columns: plutoColumns,
      rows: plutoRows,
      onSorted: onSort != null
          ? (PlutoGridOnSortedEvent event) {
              if (event.column.field == '__idx') return;
              final key = event.column.field;
              final ascending = event.column.sort == PlutoColumnSort.ascending;
              onSort!(key, ascending);
            }
          : null,
      configuration: PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          gridBorderColor: bordered ? cs.outlineVariant : Colors.transparent,
          borderColor: cs.outlineVariant,
          activatedBorderColor: cs.primary,
          columnTextStyle: textTheme.labelMedium ?? const TextStyle(),
          cellTextStyle: textTheme.bodySmall ?? const TextStyle(),
          columnHeight: 40,
          rowHeight: 40,
          oddRowColor: striped ? cs.surfaceContainerLowest : null,
          evenRowColor: striped ? cs.surface : null,
          activatedColor: cs.primaryContainer.withValues(alpha: 0.3),
          gridBackgroundColor: cs.surface,
          rowColor: cs.surface,
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    final theme = Theme.of(context);
    final cardCols = columns.where((c) => c.showInCard).toList();
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
      },
    );
  }
}
