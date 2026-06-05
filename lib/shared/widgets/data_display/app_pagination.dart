import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  const AppPagination({
    super.key,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
  });

  final int total;
  final int page;
  final int pageSize;
  final void Function(int page) onPageChanged;

  int get _totalPages => pageSize > 0 ? (total / pageSize).ceil() : 1;
  int get _firstItem => (page - 1) * pageSize + 1;
  int get _lastItem => (_firstItem + pageSize - 1).clamp(0, total);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Exibindo $_firstItem a $_lastItem de $total registros',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: page > 1 ? () => onPageChanged(page - 1) : null,
        ),
        ...List.generate(_totalPages, (i) {
          final p = i + 1;
          return _PageButton(
            page: p,
            selected: p == page,
            onTap: () => onPageChanged(p),
          );
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: page < _totalPages ? () => onPageChanged(page + 1) : null,
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.page,
    required this.selected,
    required this.onTap,
  });

  final int page;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: selected
            ? BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Text(
          '$page',
          style: TextStyle(
            color: selected ? theme.colorScheme.onPrimary : null,
            fontWeight: selected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
