import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Limpa os filtros da tela ao pressionar Esc, com o foco em qualquer
/// lugar do subtree (tabela, campos de filtro, etc.).
class ClearFiltersOnEscape extends StatelessWidget {
  const ClearFiltersOnEscape({
    super.key,
    required this.onClear,
    required this.child,
  });

  final VoidCallback onClear;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): onClear},
      child: Focus(autofocus: true, child: child),
    );
  }
}
