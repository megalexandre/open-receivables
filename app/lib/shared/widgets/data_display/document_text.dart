import 'package:flutter/material.dart';

class DocumentText extends StatelessWidget {
  const DocumentText(this.document, {super.key, this.style});

  final String document;
  final TextStyle? style;

  static String format(String document) {
    final d = document.replaceAll(RegExp(r'\D'), '');
    if (d.length == 11) {
      return '${d.substring(0, 3)}.${d.substring(3, 6)}.${d.substring(6, 9)}-${d.substring(9)}';
    }
    if (d.length == 14) {
      return '${d.substring(0, 2)}.${d.substring(2, 5)}.${d.substring(5, 8)}/${d.substring(8, 12)}-${d.substring(12)}';
    }
    return document;
  }

  @override
  Widget build(BuildContext context) {
    return Text(format(document), style: style);
  }
}
