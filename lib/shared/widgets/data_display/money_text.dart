import 'package:flutter/material.dart';
import 'package:organizagrana/shared/utils/app_formats.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(this.value, {super.key, this.style});

  final double value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(currencyFormat.format(value), style: style);
  }
}
