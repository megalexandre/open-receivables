import 'package:flutter/material.dart';
import 'package:organizagrana/features/water_quality/domain/water_analysis.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';

class WaterQualityTable extends StatelessWidget {
  const WaterQualityTable({
    super.key,
    required this.analyses,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
    this.onLoadMore,
    this.hasMore = false,
    this.onDelete,
  });

  final List<WaterAnalysis> analyses;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;
  final VoidCallback? onLoadMore;
  final bool hasMore;
  final void Function(String reference)? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppTable<WaterAnalysis>(
      items: analyses,
      total: 0,
      page: 1,
      pageSize: analyses.length + 1,
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
          label: 'Referência',
          sortKey: 'reference',
          builder: (a) => Text(a.reference),
        ),
        AppTableColumn(
          label: 'Parâmetro',
          sortKey: 'parameter',
          builder: (a) => Text(a.parameter),
        ),
        AppTableColumn(
          label: 'Exigido',
          sortKey: 'required',
          numeric: true,
          builder: (a) => Text(_fmt(a.required_)),
        ),
        AppTableColumn(
          label: 'Analisado',
          sortKey: 'analyzed',
          numeric: true,
          builder: (a) => Text(_fmt(a.analyzed)),
        ),
        AppTableColumn(
          label: 'Conformidade',
          sortKey: 'conformity',
          numeric: true,
          builder: (a) => Text(_fmt(a.conformity)),
        ),
        if (onDelete != null)
          AppTableColumn(
            label: '',
            showInCard: false,
            builder: (a) => IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              tooltip: 'Excluir referência ${a.reference}',
              onPressed: () => onDelete!(a.reference),
            ),
          ),
      ],
    );
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
}
