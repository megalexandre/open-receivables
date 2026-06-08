import 'package:flutter/material.dart';

const _addressTypes = ['Alameda', 'Avenida', 'Fazenda', 'Praça', 'Rua', 'Sítio', 'Travessa', 'Vila'];

class AddressFilterBar extends StatefulWidget {
  const AddressFilterBar({super.key, required this.onFilter});

  final void Function({String? addressType, String? name}) onFilter;

  @override
  State<AddressFilterBar> createState() => _AddressFilterBarState();
}

class _AddressFilterBarState extends State<AddressFilterBar> {
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

  void _clear() {
    setState(() {
      _addressType = null;
      _nameCtrl.clear();
    });
    widget.onFilter(addressType: null, name: null);
  }

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
              onChanged: (v) {
                setState(() => _addressType = v);
                _notify();
              },
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
              onChanged: (_) => _notify(),
            ),
          ),
          const SizedBox(width: 8),
          if (_addressType != null || _nameCtrl.text.isNotEmpty)
            TextButton(
              onPressed: _clear,
              child: const Text('Limpar'),
            ),
        ],
      ),
    );
  }
}
