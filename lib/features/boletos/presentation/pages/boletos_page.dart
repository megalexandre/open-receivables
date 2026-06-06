import 'package:flutter/material.dart';
import 'package:organizagrana/features/boletos/data/boletos_service.dart';
import 'package:organizagrana/features/boletos/domain/boleto.dart';
import 'package:organizagrana/features/boletos/domain/boleto_failure.dart';
import 'package:organizagrana/features/boletos/presentation/widgets/boleto_delete_dialog.dart';
import 'package:organizagrana/features/boletos/presentation/widgets/boleto_filter_bar.dart';
import 'package:organizagrana/features/boletos/presentation/widgets/boleto_form_dialog.dart';
import 'package:organizagrana/features/boletos/presentation/widgets/boletos_table.dart';

class BoletosPage extends StatefulWidget {
  const BoletosPage({super.key, required this.service});

  final BoletosService service;

  @override
  State<BoletosPage> createState() => _BoletosPageState();
}

class _BoletosPageState extends State<BoletosPage> {
  List<Boleto> _boletos = [];
  int _total = 0;
  int _page = 1;
  static const int _pageSize = 10;
  String? _sortBy;
  bool _sortAscending = true;
  bool _loading = true;
  String? _error;
  BoletoFilter _filter = const BoletoFilter();

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
          _boletos = result.boletos;
          _total = result.total;
          _loading = false;
        });
      }
    } on BoletoFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  void _onFilter(BoletoFilter filter) {
    setState(() {
      _filter = filter;
      _page = 1;
    });
    _load();
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
    final result = await BoletoFormDialog.show(context);
    if (result == null) return;
    try {
      await widget.service.create(result);
      _load();
    } on BoletoFailure catch (e) {
      if (mounted) _showError(e.message);
    }
  }

  Future<void> _confirmDelete(Boleto boleto) async {
    final confirmed = await showBoletoDeleteDialog(context, boleto);
    if (!confirmed) return;
    try {
      await widget.service.delete(boleto.id);
      _load();
    } on BoletoFailure catch (e) {
      if (mounted) _showError(e.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildContent(context),
        Positioned(
          right: 24,
          bottom: 24,
          child: FloatingActionButton(
            onPressed: _openForm,
            tooltip: 'Novo Boleto',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
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
                    'Gestão de Faturas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Consulte e gerencie os boletos emitidos.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          BoletoFilterBar(
            onFilter: _onFilter,
            onPrint: () {},
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
                child: BoletosTable(
                  boletos: _boletos,
                  total: _total,
                  page: _page,
                  pageSize: _pageSize,
                  onPageChanged: _onPageChanged,
                  onSort: _onSort,
                  sortKey: _sortBy,
                  sortAscending: _sortAscending,
                  onDelete: _confirmDelete,
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
