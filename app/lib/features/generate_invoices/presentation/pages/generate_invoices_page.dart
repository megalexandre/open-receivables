import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizagrana/features/addresses/data/addresses_service.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/generate_invoices/data/generate_invoices_service.dart';
import 'package:organizagrana/features/generate_invoices/domain/generate_invoices_failure.dart';
import 'package:organizagrana/features/generate_invoices/domain/invoice_candidate.dart';
import 'package:organizagrana/features/generate_invoices/presentation/widgets/invoice_candidates_table.dart';

class GenerateInvoicesPage extends StatefulWidget {
  const GenerateInvoicesPage({
    super.key,
    required this.service,
    required this.addressesService,
  });

  final GenerateInvoicesService service;
  final AddressesService addressesService;

  @override
  State<GenerateInvoicesPage> createState() => _GenerateInvoicesPageState();
}

class _GenerateInvoicesPageState extends State<GenerateInvoicesPage> {
  List<InvoiceCandidate> _candidates = [];
  int _total = 0;
  double _totalValue = 0;
  bool _loading = true;
  String? _error;

  List<Address> _addresses = [];
  final Set<String> _selected = {};

  InvoiceCandidateFilter _filter = InvoiceCandidateFilter(
    competencia: DateFormat('MM/yyyy').format(DateTime.now()),
  );

  DateTime? _dueDate;

  static const _meterTypes = ['Todos', 'Residencial', 'Comercial', 'Industrial'];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
    _load();
  }

  Future<void> _loadAddresses() async {
    try {
      final result = await widget.addressesService.list(pageSize: 200);
      if (mounted) setState(() => _addresses = result.addresses);
    } catch (_) {}
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _selected.clear();
    });
    try {
      final result = await widget.service.listCandidates(filter: _filter);
      if (mounted) {
        setState(() {
          _candidates = result.candidates;
          _total = result.total;
          _totalValue = result.totalValue;
          _loading = false;
        });
      }
    } on GenerateInvoicesFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  Future<void> _confirmGenerate() async {
    if (_selected.isEmpty) {
      _showError('Selecione ao menos uma fatura para gerar.');
      return;
    }
    if (_dueDate == null) {
      _showError('Informe a data de vencimento.');
      return;
    }
    try {
      await widget.service.generate(GenerateInvoicesRequest(
        candidateIds: _selected.toList(),
        dueDate: DateFormat('yyyy-MM-dd').format(_dueDate!),
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selected.length} fatura(s) gerada(s) com sucesso.'),
            backgroundColor: Colors.green,
          ),
        );
        _load();
      }
    } on GenerateInvoicesFailure catch (e) {
      _showError(e.message);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void _toggleAll(bool value) {
    setState(() {
      if (value) {
        _selected.addAll(_candidates.map((c) => c.id));
      } else {
        _selected.clear();
      }
    });
  }

  void _toggle(String id, bool value) {
    setState(() {
      if (value) {
        _selected.add(id);
      } else {
        _selected.remove(id);
      }
    });
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
                    'Gerar Faturas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Processamento e emissão de cobranças em lote.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FilterBar(
            addresses: _addresses,
            meterTypes: _meterTypes,
            initialFilter: _filter,
            onSearch: (f) {
              setState(() => _filter = f);
              _load();
            },
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
                child: InvoiceCandidatesTable(
                  candidates: _candidates,
                  selected: _selected,
                  onToggle: _toggle,
                  onToggleAll: _toggleAll,
                  loading: _loading,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _Footer(
            total: _total,
            totalValue: _totalValue,
            selectedCount: _selected.length,
            dueDate: _dueDate,
            onDueDateChanged: (d) => setState(() => _dueDate = d),
            onToggleAll: () => _toggleAll(_selected.length != _candidates.length),
            onConfirm: _confirmGenerate,
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatefulWidget {
  const _FilterBar({
    required this.addresses,
    required this.meterTypes,
    required this.initialFilter,
    required this.onSearch,
  });

  final List<Address> addresses;
  final List<String> meterTypes;
  final InvoiceCandidateFilter initialFilter;
  final void Function(InvoiceCandidateFilter) onSearch;

  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  late String _meterType = widget.meterTypes.first;
  late String _competencia = widget.initialFilter.competencia ?? '';
  String? _addressId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 160,
              child: DropdownButtonFormField<String>(
                initialValue: _meterType,
                decoration: const InputDecoration(
                  labelText: 'Tipo Hidrômetro',
                  isDense: true,
                ),
                items: widget.meterTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _meterType = v ?? _meterType),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: TextFormField(
                initialValue: _competencia,
                decoration: const InputDecoration(
                  labelText: 'Competência',
                  isDense: true,
                  hintText: 'MM/AAAA',
                ),
                onChanged: (v) => _competencia = v,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String?>(
                initialValue: _addressId,
                decoration: const InputDecoration(
                  labelText: 'Logradouro',
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem(
                    child: Text('Selecione o endereço...'),
                  ),
                  ...widget.addresses.map(
                    (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                  ),
                ],
                onChanged: (v) => setState(() => _addressId = v),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () => widget.onSearch(InvoiceCandidateFilter(
                meterType: _meterType,
                competencia: _competencia,
                addressId: _addressId,
              )),
              icon: const Icon(Icons.search, size: 16),
              label: const Text('Buscar'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _meterType = widget.meterTypes.first;
                  _competencia = '';
                  _addressId = null;
                });
                widget.onSearch(const InvoiceCandidateFilter());
              },
              child: const Text('Limpar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.total,
    required this.totalValue,
    required this.selectedCount,
    required this.dueDate,
    required this.onDueDateChanged,
    required this.onToggleAll,
    required this.onConfirm,
  });

  final int total;
  final double totalValue;
  final int selectedCount;
  final DateTime? dueDate;
  final void Function(DateTime?) onDueDateChanged;
  final VoidCallback onToggleAll;
  final VoidCallback onConfirm;

  String get _dueDateLabel => dueDate == null
      ? '--/--/----'
      : DateFormat('dd/MM/yyyy').format(dueDate!);

  String get _totalFormatted =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalValue);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.info_outline,
                size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              '$total faturas encontradas, valor total: $_totalFormatted',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            SizedBox(
              width: 150,
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  onDueDateChanged(picked);
                },
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de Vencimento',
                    isDense: true,
                    suffixIcon: Icon(Icons.calendar_today_outlined, size: 16),
                  ),
                  child: Text(
                    _dueDateLabel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: onToggleAll,
              icon: const Icon(Icons.checklist, size: 16),
              label: const Text('Marcar/Desmarcar Todos'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.check_circle_outline, size: 16),
              label: Text(
                selectedCount > 0
                    ? 'Confirmar Geração ($selectedCount)'
                    : 'Confirmar Geração',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
