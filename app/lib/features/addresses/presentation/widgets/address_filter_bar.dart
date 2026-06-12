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

  final void Function({String? addressType, String? name, bool? active})
      onFilter;

  @override
  State<AddressFilterBar> createState() => AddressFilterBarState();
}

class AddressFilterBarState extends State<AddressFilterBar> {
  String? _addressType;
  final _nameCtrl = TextEditingController();
  bool? _active;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onFilter(
      addressType: _addressType,
      name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
      active: _active,
    );
  }

  void clear() {
    setState(() {
      _addressType = null;
      _nameCtrl.clear();
      _active = null;
    });
    widget.onFilter(addressType: null, name: null, active: null);
  }

  bool get _hasFilters =>
      _addressType != null || _nameCtrl.text.isNotEmpty || _active != null;

  @override
  Widget build(BuildContext context) {
    final typeField = DropdownButtonFormField<String>(
      initialValue: _addressType,
      isExpanded: true,
      hint: const Text('Tipo'),
      decoration: const InputDecoration(isDense: true),
      items: [
        const DropdownMenuItem(child: Text('Todos')),
        ..._addressTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))),
      ],
      onChanged: (v) => setState(() => _addressType = v),
    );

    final nameField = TextField(
      controller: _nameCtrl,
      decoration: const InputDecoration(
        hintText: 'Buscar por nome...',
        isDense: true,
        prefixIcon: Icon(Icons.search, size: 16),
      ),
      onSubmitted: (_) => _notify(),
    );

    final activeField = DropdownButtonFormField<bool>(
      initialValue: _active,
      isExpanded: true,
      hint: const Text('Situação'),
      decoration: const InputDecoration(isDense: true),
      items: const [
        DropdownMenuItem(child: Text('Ativos')),
        DropdownMenuItem(value: false, child: Text('Inativos')),
      ],
      onChanged: (v) => setState(() => _active = v),
    );

    final actions = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 8,
      children: [
        if (_hasFilters)
          TextButton(onPressed: clear, child: const Text('Limpar')),
        FilledButton.icon(
          onPressed: _notify,
          icon: const Icon(Icons.search, size: 16),
          label: const Text('Consultar'),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Estreito: campos empilhados ocupando 100% (como col-12).
          final fields = constraints.maxWidth < 600
              ? Column(
                  spacing: 12,
                  children: [typeField, nameField, activeField],
                )
              // Largo: 25/50/25 (como col-3/col-6/col-3).
              : Row(
                  spacing: 12,
                  children: [
                    Expanded(child: typeField),
                    Expanded(flex: 2, child: nameField),
                    Expanded(child: activeField),
                  ],
                );
          return Column(spacing: 12, children: [fields, actions]);
        },
      ),
    );
  }
}
