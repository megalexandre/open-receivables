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
    this.flex = 1,
  });

  final String label;
  final Widget Function(T item) builder;
  final String? sortKey;
  final bool numeric;
  final bool showInCard;

  /// Proporção de largura em relação às outras colunas (flex 2 = 2x mais
  /// larga que uma coluna flex 1).
  final double flex;
}

class AppTable<T> extends StatefulWidget {
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
    this.onLoadMore,
    this.hasMore = false,
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

  /// Quando fornecido, ativa o modo infinite scroll (oculta a paginação).
  final VoidCallback? onLoadMore;

  /// Indica se ainda há mais registros para carregar.
  final bool hasMore;

  @override
  State<AppTable<T>> createState() => _AppTableState<T>();
}

class _AppTableState<T> extends State<AppTable<T>> {
  PlutoGridStateManager? _stateManager;

  void _onLoaded(PlutoGridOnLoadedEvent event) {
    _stateManager = event.stateManager;
    if (widget.onLoadMore != null) {
      _stateManager!.scroll.bodyRowsVertical?.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkNeedMore());
    }
  }

  void _onScroll() {
    final pos = _stateManager?.scroll.bodyRowsVertical?.position;
    if (pos == null) return;
    if (!widget.hasMore || widget.loading) return;
    if (pos.pixels >= pos.maxScrollExtent - 120) {
      widget.onLoadMore!();
    }
  }

  void _checkNeedMore() {
    if (!widget.hasMore || widget.loading) return;
    final pos = _stateManager?.scroll.bodyRowsVertical?.position;
    if (pos == null || pos.maxScrollExtent > 120) return;
    widget.onLoadMore!();
  }

  List<PlutoRow> _buildPlutoRows() {
    return widget.items.indexed.map((entry) {
      final (i, _) = entry;
      return PlutoRow(cells: {
        '__idx': PlutoCell(value: i),
        for (final col in widget.columns) _fieldFor(col): PlutoCell(value: ''),
      });
    }).toList();
  }

  @override
  void didUpdateWidget(AppTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // atualiza linhas imperativamente para não recriar o PlutoGrid inteiro
    if (!identical(oldWidget.items, widget.items)) {
      final sm = _stateManager;
      if (sm != null) {
        sm.removeAllRows();
        if (widget.items.isNotEmpty) {
          sm.appendRows(_buildPlutoRows());
        }
      }
      if (widget.onLoadMore != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _checkNeedMore());
      }
    }

    if (oldWidget.onLoadMore == null && widget.onLoadMore != null) {
      _stateManager?.scroll.bodyRowsVertical?.addListener(_onScroll);
    } else if (oldWidget.onLoadMore != null && widget.onLoadMore == null) {
      _stateManager?.scroll.bodyRowsVertical?.removeListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _stateManager?.scroll.bodyRowsVertical?.removeListener(_onScroll);
    super.dispose();
  }

  bool get _infiniteMode => widget.onLoadMore != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: widget.loading && widget.items.isEmpty && _stateManager == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => constraints.maxWidth >= widget.breakpoint
                          ? _buildTable(context)
                          : _buildCards(context),
                    ),
                    if (widget.loading && widget.items.isEmpty)
                      const ColoredBox(
                        color: Colors.black12,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
        ),
        if (!_infiniteMode) ...[
          const SizedBox(height: 12),
          AppPagination(
            total: widget.total,
            page: widget.page,
            pageSize: widget.pageSize,
            onPageChanged: widget.onPageChanged,
          ),
        ],
        if (_infiniteMode && widget.loading && widget.items.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  String _fieldFor(AppTableColumn<T> col) => col.sortKey ?? col.label;

  Widget _buildTable(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final plutoColumns = <PlutoColumn>[
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
      ...widget.columns.map((col) {
        final isActions = !col.showInCard;
        return PlutoColumn(
          title: col.label,
          field: _fieldFor(col),
          type: PlutoColumnType.text(),
          textAlign: col.numeric ? PlutoColumnTextAlign.right : PlutoColumnTextAlign.left,
          titleTextAlign: col.numeric ? PlutoColumnTextAlign.right : PlutoColumnTextAlign.left,
          enableSorting: col.sortKey != null && widget.onSort != null,
          enableFilterMenuItem: false,
          enableColumnDrag: false,
          enableContextMenu: false,
          enableDropToResize: !isActions,
          width: isActions ? 96 : 150 * col.flex,
          minWidth: isActions ? 96 : 80,
          suppressedAutoSize: isActions,
          renderer: (rendererContext) {
            final idx = rendererContext.row.cells['__idx']!.value as int;
            return DefaultTextStyle.merge(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: Align(
                alignment: col.numeric ? Alignment.centerRight : Alignment.centerLeft,
                child: col.builder(widget.items[idx]),
              ),
            );
          },
        );
      }),
    ];

    return PlutoGrid(
      columns: plutoColumns,
      rows: _buildPlutoRows(),
      mode: PlutoGridMode.readOnly,
      onLoaded: _onLoaded,
      onSorted: widget.onSort != null
          ? (PlutoGridOnSortedEvent event) {
              if (event.column.field == '__idx') return;
              final key = event.column.field;
              final ascending = event.column.sort == PlutoColumnSort.ascending;
              widget.onSort!(key, ascending);
            }
          : null,
      configuration: PlutoGridConfiguration(
        columnSize: const PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.scale,
        ),
        style: PlutoGridStyleConfig(
          gridBorderColor: widget.bordered ? cs.outlineVariant : Colors.transparent,
          borderColor: cs.outlineVariant,
          activatedBorderColor: cs.primary,
          columnTextStyle: textTheme.labelMedium ?? const TextStyle(),
          cellTextStyle: textTheme.bodySmall ?? const TextStyle(),
          columnHeight: 40,
          rowHeight: 40,
          oddRowColor: widget.striped ? cs.surfaceContainerLowest : cs.surface,
          evenRowColor: cs.surface,
          activatedColor: cs.primaryContainer.withValues(alpha: 0.3),
          gridBackgroundColor: cs.surface,
          rowColor: cs.surface,
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    final theme = Theme.of(context);
    final cardCols = widget.columns.where((c) => c.showInCard).toList();
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
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
