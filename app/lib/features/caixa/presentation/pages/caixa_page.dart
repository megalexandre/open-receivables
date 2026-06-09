import 'package:flutter/material.dart';
import 'package:organizagrana/features/caixa/data/caixa_service.dart';
import 'package:organizagrana/features/caixa/domain/caixa_failure.dart';
import 'package:organizagrana/features/caixa/domain/caixa_posting.dart';
import 'package:organizagrana/features/caixa/presentation/widgets/caixa_table.dart';

class CaixaPage extends StatefulWidget {
  const CaixaPage({super.key, required this.service});

  final CaixaService service;

  @override
  State<CaixaPage> createState() => _CaixaPageState();
}

class _CaixaPageState extends State<CaixaPage> {
  List<CaixaPosting> _postings = [];
  int _total = 0;
  double _totalValue = 0;
  int _page = 1;
  static const int _pageSize = 50;
  String? _sortBy;
  bool _sortAscending = false;
  bool _loading = true;
  String? _error;
  CaixaFilter _filter = CaixaFilter(
    startDate: DateTime(DateTime.now().year, DateTime.now().month),
    endDate: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

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
        filter: _filter,
      );
      if (mounted) {
        setState(() {
          _postings = result.postings;
          _total = result.total;
          _totalValue = result.totalValue;
          _loading = false;
        });
      }
    } on CaixaFailure catch (e) {
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
                    'Postagens Financeiras',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Visão geral detalhada das transações diárias de recebíveis.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune, size: 16),
                label: const Text('Filtros Avançados'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('Exportar CSV'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CaixaTable(
                  postings: _postings,
                  total: _total,
                  totalValue: _totalValue,
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
          const SizedBox(height: 16),
          _CaixaFilterBar(
            filter: _filter,
            onConsult: (f) {
              setState(() {
                _filter = f;
                _page = 1;
              });
              _load();
            },
          ),
        ],
      ),
    );
  }
}

class _CaixaFilterBar extends StatefulWidget {
  const _CaixaFilterBar({required this.filter, required this.onConsult});

  final CaixaFilter filter;
  final void Function(CaixaFilter) onConsult;

  @override
  State<_CaixaFilterBar> createState() => _CaixaFilterBarState();
}

class _CaixaFilterBarState extends State<_CaixaFilterBar> {
  late DateTime? _start = widget.filter.startDate;
  late DateTime? _end = widget.filter.endDate;
  PaymentMethod? _method;

  Future<void> _pickDate(bool isStart) async {
    final initial = isStart
        ? (_start ?? DateTime.now())
        : (_end ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
    });
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '--/--/----';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _DateField(
              label: 'Início',
              value: _fmtDate(_start),
              onTap: () => _pickDate(true),
            ),
            const SizedBox(width: 12),
            _DateField(
              label: 'Final',
              value: _fmtDate(_end),
              onTap: () => _pickDate(false),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<PaymentMethod?>(
                initialValue: _method,
                decoration: const InputDecoration(
                  labelText: 'Tipo Pagamento',
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem(child: Text('Todos os Tipos')),
                  ...PaymentMethod.values.map(
                    (m) => DropdownMenuItem(value: m, child: Text(m.label)),
                  ),
                ],
                onChanged: (v) => setState(() => _method = v),
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.print_outlined, size: 16),
              label: const Text('Imprimir'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => widget.onConsult(CaixaFilter(
                startDate: _start,
                endDate: _end,
                paymentMethod: _method,
              )),
              icon: const Icon(Icons.search, size: 16),
              label: const Text('Consultar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            isDense: true,
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
          ),
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}
