import 'package:flutter/material.dart';

class CategoryFilterBar extends StatefulWidget {
  const CategoryFilterBar({super.key, required this.onFilter});

  final void Function({bool? active}) onFilter;

  @override
  State<CategoryFilterBar> createState() => CategoryFilterBarState();
}

class CategoryFilterBarState extends State<CategoryFilterBar> {
  bool? _active;

  void _notify() {
    widget.onFilter(active: _active);
  }

  void clear() {
    setState(() => _active = null);
    widget.onFilter(active: null);
  }

  bool get _hasFilters => _active != null;

  @override
  Widget build(BuildContext context) {
    final activeField = DropdownButtonFormField<bool>(
      initialValue: _active,
      isExpanded: true,
      hint: const Text('Situação'),
      decoration: const InputDecoration(isDense: true),
      items: const [
        DropdownMenuItem(child: Text('Ativas')),
        DropdownMenuItem(value: false, child: Text('Inativas')),
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
          // Estreito: campo em 100%; largo: 25% à esquerda (como col-3).
          final fields = constraints.maxWidth < 600
              ? activeField
              : Row(
                  spacing: 12,
                  children: [
                    Expanded(child: activeField),
                    const Spacer(flex: 3),
                  ],
                );
          return Column(spacing: 12, children: [fields, actions]);
        },
      ),
    );
  }
}
