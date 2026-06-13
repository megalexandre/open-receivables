import 'package:flutter/material.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';

class ConnectionFilterBar extends StatefulWidget {
  const ConnectionFilterBar({
    super.key,
    required this.addresses,
    required this.onFilter,
  });

  final List<Address> addresses;
  final void Function({String? member, String? address, bool? active}) onFilter;

  @override
  State<ConnectionFilterBar> createState() => ConnectionFilterBarState();
}

class ConnectionFilterBarState extends State<ConnectionFilterBar> {
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
    _notifyChanges();
  }

  void _notifyChanges() {
    final member = _memberCtrl.text.trim();
    widget.onFilter(
      member: member.isEmpty ? null : member,
      address: _addressFilter,
      active: _activeFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final memberField = TextField(
      controller: _memberCtrl,
      decoration: const InputDecoration(
        labelText: 'Sócio',
        hintText: 'Nome do sócio...',
        isDense: true,
      ),
      onChanged: (_) => _notifyChanges(),
    );

    final addressField = DropdownButtonFormField<String?>(
      initialValue: _addressFilter,
      isExpanded: true,
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
        _notifyChanges();
      },
    );

    final statusField = DropdownButtonFormField<bool?>(
      initialValue: _activeFilter,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Status',
        isDense: true,
      ),
      items: const [
        DropdownMenuItem(child: Text('Todos')),
        DropdownMenuItem(value: true, child: Text('Ativos')),
        DropdownMenuItem(value: false, child: Text('Inativos')),
      ],
      onChanged: (v) {
        setState(() => _activeFilter = v);
        _notifyChanges();
      },
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                spacing: 12,
                children: [memberField, addressField, statusField],
              );
            }
            return Row(
              spacing: 12,
              children: [
                Expanded(flex: 4, child: memberField),
                Expanded(flex: 3, child: addressField),
                Expanded(flex: 2, child: statusField),
              ],
            );
          },
        ),
      ),
    );
  }
}
