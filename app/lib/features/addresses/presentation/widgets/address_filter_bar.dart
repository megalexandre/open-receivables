import 'package:flutter/material.dart';

const _addressTypes = [
  'Alameda',
  'Avenida',
  'Fazenda',
  'Praça',
  'Rua',
  'Sítio',
  'Travessa',
  'Vila',
];

class AddressFilterBar extends StatefulWidget {
  const AddressFilterBar({super.key, required this.onFilter});

  final void Function({String? addressType, String? name}) onFilter;

  @override
  State<AddressFilterBar> createState() => AddressFilterBarState();
}

class AddressFilterBarState extends State<AddressFilterBar> {
  String? _addressType;
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onFilter(
      addressType: _addressType,
      name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
    );
  }

  void clear() {
    setState(() {
      _addressType = null;
      _nameCtrl.clear();
    });
    widget.onFilter(addressType: null, name: null);
  }

  bool get _hasFilters => _addressType != null || _nameCtrl.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String>(
              initialValue: _addressType,
              hint: const Text('Tipo'),
              decoration: const InputDecoration(isDense: true),
              items: [
                const DropdownMenuItem(child: Text('Todos')),
                ..._addressTypes.map(
                  (t) => DropdownMenuItem(value: t, child: Text(t)),
                ),
              ],
              onChanged: (v) => setState(() => _addressType = v),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 260,
            child: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Buscar por nome...',
                isDense: true,
                prefixIcon: Icon(Icons.search, size: 16),
              ),
              onSubmitted: (_) => _notify(),
            ),
          ),
          const Spacer(),
          if (_hasFilters)
            TextButton(onPressed: clear, child: const Text('Limpar')),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _notify,
            icon: const Icon(Icons.search, size: 16),
            label: const Text('Consultar'),
          ),
        ],
      ),
    );
  }
}
