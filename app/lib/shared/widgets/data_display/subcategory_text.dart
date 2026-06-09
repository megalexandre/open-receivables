import 'package:flutter/material.dart';

class SubcategoryText extends StatelessWidget {
  const SubcategoryText({required this.value, super.key});

  final String? value;

  @override
  Widget build(BuildContext context) => Text(value ?? '');
}
