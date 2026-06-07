import 'package:flutter/material.dart';
import 'package:organizagrana/shared/widgets/form/subcategory_dropdown.dart';

class SubcategoryText extends StatelessWidget {
  const SubcategoryText({required this.value, super.key});

  final int? value;

  @override
  Widget build(BuildContext context) {
    return Text(SubcategoryDropdown.items[value] ?? '');
  }
}
