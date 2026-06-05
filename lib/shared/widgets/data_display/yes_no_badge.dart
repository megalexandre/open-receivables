import 'package:flutter/material.dart';

class YesNoBadge extends StatelessWidget {
  const YesNoBadge({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Text(value ? 'Sim' : 'Não'),
      ],
    );
  }
}
