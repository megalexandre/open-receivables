import 'package:flutter/material.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';
import 'package:organizagrana/shared/widgets/data_display/money_text.dart';
import 'package:organizagrana/shared/widgets/data_display/yes_no_badge.dart';

class ConnectionsTable extends StatelessWidget {
  const ConnectionsTable({
    super.key,
    required this.connections,
    required this.onDelete,
    required this.onReactivate,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
    this.onLoadMore,
    this.hasMore = false,
  });

  final List<Connection> connections;
  final void Function(Connection) onDelete;
  final void Function(Connection) onReactivate;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return AppTable<Connection>(
      items: connections,
      total: connections.length,
      page: 1,
      pageSize: connections.length,
      onPageChanged: (_) {},
      striped: true,
      onSort: onSort,
      sortKey: sortKey,
      sortAscending: sortAscending,
      loading: loading,
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      columns: [
        AppTableColumn(
          label: 'Sócio',
          sortKey: 'memberName',
          flex: 2,
          builder: (c) => Text(c.memberName),
        ),
        AppTableColumn(
          label: 'Endereço',
          sortKey: 'address',
          flex: 2,
          builder: (c) => Text(c.address),
        ),
        AppTableColumn(
          label: 'Status',
          sortKey: 'active',
          builder: (c) => YesNoBadge(value: c.active),
        ),
        AppTableColumn(
          label: 'Categoria',
          sortKey: 'categoryName',
          flex: 1.2,
          builder: (c) => Text(c.categoryName),
        ),
        AppTableColumn(
          label: 'Valor',
          sortKey: 'value',
          numeric: true,
          builder: (c) => MoneyText(c.value),
        ),
        AppTableColumn(
          label: 'Ações',
          showInCard: false,
          centerTitle: true,
          builder: (c) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: c.active
                ? [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      tooltip: 'Inativar',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onDelete(c),
                    ),
                  ]
                : [
                    IconButton(
                      icon: const Icon(Icons.restore, size: 16),
                      tooltip: 'Reativar',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onReactivate(c),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}
