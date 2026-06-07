import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/data/addresses_service.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/connections/data/connections_service.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';
import 'package:organizagrana/features/connections/domain/connection_failure.dart';
import 'package:organizagrana/features/connections/presentation/widgets/connection_delete_dialog.dart';
import 'package:organizagrana/features/connections/presentation/widgets/connection_summary_cards.dart';
import 'package:organizagrana/features/connections/presentation/widgets/connection_view_dialog.dart';
import 'package:organizagrana/features/connections/presentation/widgets/connections_table.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({
    super.key,
    required this.service,
    required this.addressesService,
  });

  final ConnectionsService service;
  final AddressesService addressesService;

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  List<Connection> _connections = [];
  ConnectionSummary? _summary;
  List<Address> _addresses = [];
  int _total = 0;
  int _page = 1;
  static const int _pageSize = 5;
  String? _sortBy;
  bool _sortAscending = true;
  bool _loading = true;
  String? _error;

  String _memberFilter = '';
  String? _addressFilter;
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    _load();
    _loadSummary();
    _loadAddresses();
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
        memberName: _memberFilter.isEmpty ? null : _memberFilter,
        address: _addressFilter,
        active: _activeFilter,
      );
      if (mounted) {
        setState(() {
          _connections = result.connections;
          _total = result.total;
          _loading = false;
        });
      }
    } on ConnectionFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadSummary() async {
    try {
      final summary = await widget.service.summary();
      if (mounted) setState(() => _summary = summary);
    } on ConnectionFailure {
      // summary é não-crítico, ignora silenciosamente
    }
  }

  Future<void> _loadAddresses() async {
    try {
      // Carrega todos os logradouros para popular o dropdown (pageSize grande)
      final result = await widget.addressesService.list(pageSize: 200);
      if (mounted) setState(() => _addresses = result.addresses);
    } catch (_) {
      // dropdown fica vazio, não bloqueia a tela
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

  void _applyFilters() {
    setState(() => _page = 1);
    _load();
  }

  Future<void> _onView(Connection connection) =>
      showConnectionViewDialog(context, connection);

  Future<void> _onDelete(Connection connection) async {
    final confirmed = await showConnectionDeleteDialog(context, connection);
    if (!confirmed) return;
    try {
      await widget.service.delete(connection.id);
      _load();
      _loadSummary();
    } on ConnectionFailure catch (e) {
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
                    'Ligações',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Gerencie as ligações de água.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_summary != null) ...[
            ConnectionSummaryCards(summary: _summary!),
            const SizedBox(height: 24),
          ],
          _FiltersRow(
            addresses: _addresses,
            onMemberChanged: (v) {
              _memberFilter = v;
              _applyFilters();
            },
            onAddressChanged: (v) {
              _addressFilter = v;
              _applyFilters();
            },
            onActiveChanged: (v) {
              _activeFilter = v;
              _applyFilters();
            },
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
                child: ConnectionsTable(
                  connections: _connections,
                  total: _total,
                  page: _page,
                  pageSize: _pageSize,
                  onPageChanged: _onPageChanged,
                  onSort: _onSort,
                  sortKey: _sortBy,
                  sortAscending: _sortAscending,
                  onView: _onView,
                  onDelete: _onDelete,
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

class _FiltersRow extends StatefulWidget {
  const _FiltersRow({
    required this.addresses,
    required this.onMemberChanged,
    required this.onAddressChanged,
    required this.onActiveChanged,
  });

  final List<Address> addresses;
  final void Function(String) onMemberChanged;
  final void Function(String?) onAddressChanged;
  final void Function(bool?) onActiveChanged;

  @override
  State<_FiltersRow> createState() => _FiltersRowState();
}

class _FiltersRowState extends State<_FiltersRow> {
  final _memberCtrl = TextEditingController();
  String? _addressFilter;
  bool? _activeFilter;

  @override
  void dispose() {
    _memberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: _memberCtrl,
                decoration: const InputDecoration(
                  labelText: 'Sócio',
                  hintText: 'Nome do sócio...',
                  isDense: true,
                ),
                onChanged: widget.onMemberChanged,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String?>(
                initialValue: _addressFilter,
                decoration: const InputDecoration(
                  labelText: 'Rua / Endereço',
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem(child: Text('Todas as ruas')),
                  ...widget.addresses.map(
                    (a) => DropdownMenuItem(
                      value: a.id,
                      child: Text(
                        '${a.type} ${a.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (v) {
                  setState(() => _addressFilter = v);
                  widget.onAddressChanged(v);
                },
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 160,
              child: DropdownButtonFormField<bool?>(
                initialValue: _activeFilter,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(child: Text('Todos')),
                  DropdownMenuItem(value: true, child: Text('Sim')),
                  DropdownMenuItem(value: false, child: Text('Não')),
                ],
                onChanged: (v) {
                  setState(() => _activeFilter = v);
                  widget.onActiveChanged(v);
                },
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.tune, size: 16),
              label: const Text('Filtros Avançados'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined, size: 16),
              label: const Text('Exportar'),
            ),
          ],
        ),
      ),
    );
  }
}
