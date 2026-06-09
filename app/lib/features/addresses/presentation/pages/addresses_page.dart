import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/data/addresses_service.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/addresses/domain/address_failure.dart';
import 'package:organizagrana/features/addresses/presentation/widgets/address_delete_dialog.dart';
import 'package:organizagrana/features/addresses/presentation/widgets/address_filter_bar.dart';
import 'package:organizagrana/features/addresses/presentation/widgets/address_form_dialog.dart';
import 'package:organizagrana/features/addresses/presentation/widgets/addresses_table.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key, required this.service});

  final AddressesService service;

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  List<Address> _addresses = [];
  int _total = 0;
  int _page = 1;
  static const int _pageSize = 20;
  String? _sortBy;
  bool _sortAscending = true;
  bool _loading = false;
  bool _hasMore = false;
  String? _error;
  String? _filterAddressType;
  String? _filterName;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

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
        addressType: _filterAddressType,
        name: _filterName,
      );
      if (mounted) {
        setState(() {
          _addresses = [..._addresses, ...result.addresses];
          _total = result.total;
          _hasMore = _addresses.length < _total;
          _page++;
          _loading = false;
        });
      }
    } on AddressFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  void _reset() {
    _addresses = [];
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

  void _onFilter({String? addressType, String? name}) {
    setState(() {
      _filterAddressType = addressType;
      _filterName = name;
      _reset();
    });
    _loadMore();
  }

  Future<void> _openForm([Address? address]) async {
    final result = await AddressFormDialog.show(context, address);
    if (result == null) return;
    try {
      if (address == null) {
        await widget.service.create(result);
      } else {
        await widget.service.update(result);
      }
      _refresh();
    } on AddressFailure catch (e) {
      if (mounted) _showError(e.message);
    }
  }

  Future<void> _confirmDelete(Address address) async {
    final confirmed = await showAddressDeleteDialog(context, address);
    if (!confirmed) return;
    try {
      await widget.service.delete(address.id);
      _refresh();
    } on AddressFailure catch (e) {
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
                    'Logradouros',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Gerencie os endereços cadastrados.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Novo Endereço'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AddressFilterBar(onFilter: _onFilter),
                    Expanded(
                      child: AddressesTable(
                        addresses: _addresses,
                        onSort: _onSort,
                        sortKey: _sortBy,
                        sortAscending: _sortAscending,
                        onEdit: _openForm,
                        onDelete: _confirmDelete,
                        loading: _loading,
                        onLoadMore: _loadMore,
                        hasMore: _hasMore,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
