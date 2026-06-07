import 'package:flutter/material.dart';
import 'package:organizagrana/features/water_quality/domain/water_analysis.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';

class WaterQualityTable extends StatelessWidget {
  const WaterQualityTable({
    super.key,
    required this.analyses,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
  });

  final List<WaterAnalysis> analyses;
  final int total;
  final int page;
  final int pageSize;
  final void Function(int page) onPageChanged;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AppTable<WaterAnalysis>(
      items: analyses,
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
          label: 'Conforme',
          sortKey: 'compliant',
          builder: (a) => _ComplianceBadge(compliant: a.compliant),
        ),
      ],
    );
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
}

class _ComplianceBadge extends StatelessWidget {
  const _ComplianceBadge({required this.compliant});

  final bool compliant;

  @override
  Widget build(BuildContext context) {
    final color = compliant ? Colors.green : Colors.red;
    final label = compliant ? 'CONFORME' : 'INCONFORME';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
