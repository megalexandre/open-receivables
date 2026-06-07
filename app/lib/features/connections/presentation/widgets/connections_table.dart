import 'package:flutter/material.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';
import 'package:organizagrana/shared/widgets/data_display/money_text.dart';
import 'package:organizagrana/shared/widgets/data_display/yes_no_badge.dart';

class ConnectionsTable extends StatelessWidget {
  const ConnectionsTable({
    super.key,
    required this.connections,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    required this.onView,
    required this.onDelete,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
  });

  final List<Connection> connections;
  final int total;
  final int page;
  final int pageSize;
  final void Function(int page) onPageChanged;
  final void Function(Connection) onView;
  final void Function(Connection) onDelete;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AppTable<Connection>(
      items: connections,
      total: total,
      page: page,
      pageSize: pageSize,
      onPageChanged: onPageChanged,
      striped: true,
      onSort: onSort,
      sortKey: sortKey,
      sortAscending: sortAscending,
      loading: loading,
      columns: [
        AppTableColumn(
          label: 'Sócio',
          sortKey: 'memberName',
          builder: (c) => Text(c.memberName),
        ),
        AppTableColumn(
          label: 'Endereço',
          sortKey: 'address',
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
          builder: (c) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 18),
                tooltip: 'Visualizar',
                onPressed: () => onView(c),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                tooltip: 'Excluir',
                onPressed: () => onDelete(c),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
