import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';

class AddressesTable extends StatelessWidget {
  const AddressesTable({
    super.key,
    required this.addresses,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    required this.onEdit,
    required this.onDelete,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
  });

  final List<Address> addresses;
  final int total;
  final int page;
  final int pageSize;
  final void Function(int page) onPageChanged;
  final void Function(Address) onEdit;
  final void Function(Address) onDelete;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AppTable<Address>(
      items: addresses,
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
          label: 'Tipo',
          sortKey: 'type',
          builder: (a) => Text(a.type),
        ),
        AppTableColumn(
          label: 'Nome',
          sortKey: 'name',
          builder: (a) => Text(a.name),
        ),
        AppTableColumn(
          label: 'CEP Base',
          sortKey: 'baseCep',
          builder: (a) => Text(a.baseCep),
        ),
        AppTableColumn(
          label: 'Ações',
          showInCard: false,
          builder: (a) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Editar',
                onPressed: () => onEdit(a),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                tooltip: 'Excluir',
                onPressed: () => onDelete(a),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
