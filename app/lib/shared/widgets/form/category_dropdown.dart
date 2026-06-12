import 'package:flutter/material.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/shared/utils/app_formats.dart';

/// Dropdown de categorias agrupado por tipo de sócio.
///
/// Os tipos seguem a ordem de [Category.memberTypes] e aparecem como
/// cabeçalhos não selecionáveis; as categorias ficam indentadas abaixo
/// de cada tipo, em ordem alfabética (ignorando acentos).
class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    required this.categories,
    required this.onChanged,
    this.initialValue,
    this.validator,
    super.key,
  });

  final List<Category> categories;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  static String _sortKey(String name) {
    const accents = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const plain = 'aaaaaeeeeiiiiooooouuuucn';
    final lower = name.toLowerCase();
    final buffer = StringBuffer();
    for (final char in lower.runes) {
      final s = String.fromCharCode(char);
      final i = accents.indexOf(s);
      buffer.write(i >= 0 ? plain[i] : s);
    }
    return buffer.toString();
  }

  List<MapEntry<String, List<Category>>> get _categoriesByMemberType {
    final grouped = <String, List<Category>>{};
    for (final c in categories) {
      grouped.putIfAbsent(c.memberType ?? 'Outros', () => []).add(c);
    }
    final types = [
      ...Category.memberTypes.where(grouped.containsKey),
      ...grouped.keys.where((t) => !Category.memberTypes.contains(t)),
    ];
    return [
      for (final type in types)
        MapEntry(
          type,
          grouped[type]!
            ..sort((a, b) => _sortKey(a.name).compareTo(_sortKey(b.name))),
        ),
    ];
  }

  // Nome encolhe com reticências; o valor fica sempre visível no fim.
  static Widget _label(Category c) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(c.name, overflow: TextOverflow.ellipsis),
          ),
          Text(' [${currencyFormat.format(c.total)}]'),
        ],
      );

  List<DropdownMenuItem<String>> _items(BuildContext context) {
    final theme = Theme.of(context);
    return [
      for (final group in _categoriesByMemberType) ...[
        DropdownMenuItem<String>(
          enabled: false,
          child: Text(
            group.key,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        for (final c in group.value)
          DropdownMenuItem<String>(
            value: c.id,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _label(c),
            ),
          ),
      ],
    ];
  }

  // Mesmo tamanho/ordem de _items, sem indentação no campo fechado.
  List<Widget> _selectedItems(BuildContext context) {
    return [
      for (final group in _categoriesByMemberType) ...[
        const SizedBox.shrink(),
        for (final c in group.value) _label(c),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: const InputDecoration(isDense: true),
      isExpanded: true,
      items: _items(context),
      selectedItemBuilder: _selectedItems,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
