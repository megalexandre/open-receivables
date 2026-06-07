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
  static const int _pageSize = 10;
  String? _sortBy;
  bool _sortAscending = true;
  bool _loading = true;
  String? _error;

  DateTime _filterDate = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    _load();
  }

  String get _reference =>
      '${_filterDate.month.toString().padLeft(2, '0')}/${_filterDate.year}';

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.service.list(
        page: _page,
        sortBy: _sortBy,
        sortAscending: _sortAscending,
        reference: _reference,
      );
      if (mounted) {
        setState(() {
          _analyses = result.analyses;
          _total = result.total;
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
    }
  }

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _load();
  }

  void _onSort(String key, bool ascending) {
    setState(() {
      _sortBy = key;
      _sortAscending = ascending;
      _page = 1;
    });
    _load();
  }

  Future<void> _openForm() async {
    final batch = await WaterAnalysisFormDialog.show(context);
    if (batch == null) return;
    try {
      await widget.service.create(batch);
      _load();
    } on WaterQualityFailure catch (e) {
      if (mounted) _showError(e.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _pickPeriod() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Filtrar por período',
    );
    if (picked == null) return;
    setState(() {
      _filterDate = DateTime(picked.year, picked.month);
      _page = 1;
    });
    _load();
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
            onConsult: _load,
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
                  total: _total,
                  page: _page,
                  pageSize: _pageSize,
                  onPageChanged: _onPageChanged,
                  onSort: _onSort,
                  sortKey: _sortBy,
                  sortAscending: _sortAscending,
                  loading: _loading,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodFilter extends StatelessWidget {
  const _PeriodFilter({
    required this.date,
    required this.onPickPeriod,
    required this.onConsult,
  });

  final DateTime date;
  final VoidCallback onPickPeriod;
  final VoidCallback onConsult;

  static const _months = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
  ];

  String get _label => '${_months[date.month - 1]} de ${date.year}';

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
        const SizedBox(width: 8),
        FilledButton.tonal(
          onPressed: onConsult,
          child: const Text('Consultar'),
        ),
      ],
    );
  }
}
