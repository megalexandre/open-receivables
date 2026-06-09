import 'package:flutter/material.dart';
import 'package:organizagrana/features/categories/domain/category.dart';

class SubcategoryDropdown extends StatelessWidget {
  const SubcategoryDropdown({
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      items: Category.memberTypes
          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(isDense: true),
    );
  }
}
