import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/data/addresses_service.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/categories/data/categories_service.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/connections/data/connections_service.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';
import 'package:organizagrana/features/connections/domain/connection_failure.dart';
import 'package:organizagrana/features/connections/presentation/widgets/connection_delete_dialog.dart';
import 'package:organizagrana/features/connections/presentation/widgets/connection_form_dialog.dart';
import 'package:organizagrana/features/connections/presentation/widgets/connections_table.dart';
import 'package:organizagrana/features/members/data/members_service.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/widgets/form/clear_filters_on_escape.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({
    super.key,
    required this.service,
    required this.addressesService,
    required this.membersService,
    required this.categoriesService,
  });

  final ConnectionsService service;
  final AddressesService addressesService;
  final MembersService membersService;
  final CategoriesService categoriesService;

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  final _filtersRowKey = GlobalKey<_FiltersRowState>();
  List<Connection> _connections = [];
  List<Address> _addresses = [];
  List<Member> _members = [];
  List<Category> _categories = [];
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
    _loadAddresses();
    _loadMembers();
    _loadCategories();
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
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadAddresses() async {
    try {
      final result = await widget.addressesService.list(pageSize: 200);
      if (mounted) setState(() => _addresses = result.addresses);
    } catch (_) {}
  }

  Future<void> _loadMembers() async {
    try {
      final result = await widget.membersService.list(pageSize: 200);
      if (mounted) setState(() => _members = result.members);
    } catch (_) {}
  }

  Future<void> _loadCategories() async {
    try {
      final result = await widget.categoriesService.list(pageSize: 200);
      if (mounted) setState(() => _categories = result.categories);
    } catch (_) {}
  }

  void _refresh() {
    setState(() => _page = 1);
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

  void _applyFilters() {
    setState(() => _page = 1);
    _load();
  }

  void _clearFilters() {
    _filtersRowKey.currentState?.clear();
    _memberFilter = '';
    _addressFilter = null;
    _activeFilter = null;
    _applyFilters();
  }

  Future<void> _openForm({Connection? connection}) async {
    final saved = await showConnectionFormDialog(
      context,
      connection: connection,
      members: _members,
      addresses: _addresses,
      categories: _categories,
      onSave: (c) => connection == null
          ? widget.service.create(c)
          : widget.service.update(c),
    );
    if (saved) _refresh();
  }

  Future<void> _onEdit(Connection connection) =>
      _openForm(connection: connection);

  Future<void> _onDelete(Connection connection) async {
    final confirmed = await showConnectionDeleteDialog(context, connection);
    if (!confirmed) return;
    try {
      await widget.service.delete(connection.id);
      _refresh();
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
    return ClearFiltersOnEscape(
      onClear: _clearFilters,
      child: Padding(
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
                const Spacer(),
                FilledButton.icon(
                  onPressed: _openForm,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nova Ligação'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _FiltersRow(
              key: _filtersRowKey,
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
                    onEdit: _onEdit,
                    onDelete: _onDelete,
                    loading: _loading,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersRow extends StatefulWidget {
  const _FiltersRow({
    super.key,
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

  void clear() {
    setState(() {
      _memberCtrl.clear();
      _addressFilter = null;
      _activeFilter = null;
    });
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
                        '${a.addressType} ${a.name}',
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
          ],
        ),
      ),
    );
  }
}
