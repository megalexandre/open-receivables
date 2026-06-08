import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';

class AddressesTable extends StatelessWidget {
  const AddressesTable({
    super.key,
    required this.addresses,
    required this.onEdit,
    required this.onDelete,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
    this.onLoadMore,
    this.hasMore = false,
  });

  final List<Address> addresses;
  final void Function(Address) onEdit;
  final void Function(Address) onDelete;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return AppTable<Address>(
      items: addresses,
      total: addresses.length,
      page: 1,
      pageSize: addresses.length,
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
          label: 'Tipo',
          sortKey: 'address_type',
          builder: (a) => Text(a.addressType),
        ),
        AppTableColumn(
          label: 'Nome',
          sortKey: 'name',
          builder: (a) => Text(a.name),
        ),
        AppTableColumn(
          label: 'Ações',
          showInCard: false,
          builder: (a) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                tooltip: 'Editar',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onEdit(a),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 16),
                tooltip: 'Excluir',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onDelete(a),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
