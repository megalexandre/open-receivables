import 'package:flutter/material.dart';

class SubcategoryDropdown extends StatelessWidget {
  const SubcategoryDropdown({
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  final int? initialValue;
  final ValueChanged<int?>? onChanged;

  static const items = {
    1: 'Sócio Fundador',
    2: 'Sócio Efetivo',
    3: 'Sócio Temporário',
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: initialValue,
      items: items.entries
          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(isDense: true),
    );
  }
}
