import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizagrana/features/boletos/domain/boleto.dart';
import 'package:organizagrana/features/boletos/presentation/widgets/boleto_status_badge.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';

class BoletosTable extends StatelessWidget {
  const BoletosTable({
    super.key,
    required this.boletos,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    required this.onDelete,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
  });

  final List<Boleto> boletos;
  final int total;
  final int page;
  final int pageSize;
  final void Function(int page) onPageChanged;
  final void Function(Boleto) onDelete;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return AppTable<Boleto>(
      items: boletos,
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
          label: 'Número',
          sortKey: 'number',
          builder: (b) => Text(b.number),
        ),
        AppTableColumn(
          label: 'Sócio',
          sortKey: 'memberName',
          builder: (b) => Text(b.memberName),
        ),
        AppTableColumn(
          label: 'Endereço',
          sortKey: 'address',
          builder: (b) => Text(b.address),
        ),
        AppTableColumn(
          label: 'Competência',
          sortKey: 'competencia',
          builder: (b) => Text(b.competencia),
        ),
        AppTableColumn(
          label: 'Valor Total',
          sortKey: 'valorTotal',
          builder: (b) => Text(currency.format(b.valorTotal)),
        ),
        AppTableColumn(
          label: 'Vencimento',
          sortKey: 'vencimento',
          builder: (b) => Text(b.vencimento),
        ),
        AppTableColumn(
          label: 'Status',
          sortKey: 'status',
          builder: (b) => BoletoStatusBadge(b.status),
        ),
        AppTableColumn(
          label: 'Ações',
          showInCard: false,
          builder: (b) => IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            tooltip: 'Excluir',
            onPressed: () => onDelete(b),
          ),
        ),
      ],
    );
  }
}
