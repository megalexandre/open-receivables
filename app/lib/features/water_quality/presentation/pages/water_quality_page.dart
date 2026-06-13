import 'package:flutter/material.dart';
import 'package:organizagrana/features/water_quality/data/water_quality_service.dart';
import 'package:organizagrana/features/water_quality/domain/water_analysis.dart';
import 'package:organizagrana/features/water_quality/domain/water_quality_failure.dart';
import 'package:organizagrana/features/water_quality/presentation/widgets/water_analysis_form_dialog.dart';
import 'package:organizagrana/features/water_quality/presentation/widgets/water_quality_table.dart';

class WaterQualityPage extends StatefulWidget {
  const WaterQualityPage({super.key, required this.service});

  final WaterQualityService service;

  @override
  State<WaterQualityPage> createState() => _WaterQualityPageState();
}

class _WaterQualityPageState extends State<WaterQualityPage> {
  List<WaterAnalysis> _analyses = [];
  int _total = 0;
  int _page = 1;
  static const int _pageSize = 20;
  String? _sortBy;
  bool _sortAscending = true;
  bool _loading = false;
  bool _hasMore = false;
  String? _error;

  DateTime? _filterDate;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  String? get _reference => _filterDate == null
      ? null
      : '${_filterDate!.month.toString().padLeft(2, '0')}/${_filterDate!.year}';

  Future<void> _loadMore() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.service.list(
        page: _page,
        pageSize: _pageSize,
        sortBy: _sortBy,
        sortAscending: _sortAscending,
        reference: _reference,
      );
      if (mounted) {
        setState(() {
          _analyses = [..._analyses, ...result.analyses];
          _total = result.total;
          _hasMore = _analyses.length < _total;
          _page++;
          _loading = false;
        });
      }
    } on WaterQualityFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  void _reset() {
    _analyses = [];
    _page = 1;
    _hasMore = false;
    _loading = false;
  }

  void _refresh() {
    setState(_reset);
    _loadMore();
  }

  void _onSort(String key, bool ascending) {
    setState(() {
      _sortBy = key;
      _sortAscending = ascending;
      _reset();
    });
    _loadMore();
  }

  Future<void> _deleteReference(String reference) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir referência'),
        content: Text(
          'Todos os registros de $reference serão excluídos permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await widget.service.delete(reference);
      _refresh();
    } on WaterQualityFailure catch (e) {
      if (mounted) _showError(e.message);
    }
  }

  Future<void> _openForm() async {
    final saved = await WaterAnalysisFormDialog.show(
      context,
      onSave: widget.service.create,
    );
    if (saved && mounted) _refresh();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _pickPeriod() async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (_) => _MonthYearPickerDialog(initial: _filterDate),
    );
    if (picked == null) return;
    setState(() {
      _filterDate = picked;
      _reset();
    });
    _loadMore();
  }

  void _clearPeriod() {
    setState(() {
      _filterDate = null;
      _reset();
    });
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Análise de Água',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Resultados das medições laboratoriais de qualidade.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _openForm,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Adicionar Análise'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _PeriodFilter(
            date: _filterDate,
            onPickPeriod: _pickPeriod,
            onClearPeriod: _filterDate != null ? _clearPeriod : null,
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: WaterQualityTable(
                  analyses: _analyses,
                  onSort: _onSort,
                  sortKey: _sortBy,
                  sortAscending: _sortAscending,
                  loading: _loading,
                  onLoadMore: _loadMore,
                  hasMore: _hasMore,
                  onDelete: _deleteReference,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  const _MonthYearPickerDialog({this.initial});
  final DateTime? initial;

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _year;
  final int _minYear = 2019;
  final int _maxYear = DateTime.now().year;

  static const _months = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.initial?.year ?? DateTime.now().year;
  }

  bool _isAvailable(int month) {
    final now = DateTime.now();
    return DateTime(_year, month).isBefore(DateTime(now.year, now.month + 1));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selected = widget.initial;
    return AlertDialog(
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _year > _minYear ? () => setState(() => _year--) : null,
          ),
          Expanded(
            child: Text(
              '$_year',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _year < _maxYear ? () => setState(() => _year++) : null,
          ),
        ],
      ),
      content: SizedBox(
        width: 280,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 12,
          itemBuilder: (_, i) {
            final month = i + 1;
            final isSelected = selected?.year == _year && selected?.month == month;
            final available = _isAvailable(month);
            return TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? cs.primary : null,
                foregroundColor: isSelected
                    ? cs.onPrimary
                    : available
                        ? null
                        : cs.onSurface.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: available
                  ? () => Navigator.of(context).pop(DateTime(_year, month))
                  : null,
              child: Text(_months[i]),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

class _PeriodFilter extends StatelessWidget {
  const _PeriodFilter({
    required this.date,
    required this.onPickPeriod,
    this.onClearPeriod,
  });

  final DateTime? date;
  final VoidCallback onPickPeriod;
  final VoidCallback? onClearPeriod;

  static const _months = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
  ];

  String get _label => date == null
      ? 'Todos os períodos'
      : '${_months[date!.month - 1]} de ${date!.year}';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Filtrar por Período',
            style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: onPickPeriod,
          icon: const Icon(Icons.calendar_today_outlined, size: 16),
          label: Text(_label),
        ),
        if (onClearPeriod != null) ...[
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            tooltip: 'Limpar filtro',
            onPressed: onClearPeriod,
          ),
        ],
      ],
    );
  }
}
