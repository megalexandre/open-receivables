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
    final totalPages = _totalPages;

    return Row(
      children: [
        Text(
          'Exibindo $_firstItem a $_lastItem de $total registros',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.first_page),
          tooltip: 'Primeira página',
          onPressed: page > 1 ? () => onPageChanged(1) : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Página anterior',
          onPressed: page > 1 ? () => onPageChanged(page - 1) : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Página $page de $totalPages',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Próxima página',
          onPressed: page < totalPages ? () => onPageChanged(page + 1) : null,
        ),
        IconButton(
          icon: const Icon(Icons.last_page),
          tooltip: 'Última página',
          onPressed: page < totalPages ? () => onPageChanged(totalPages) : null,
        ),
      ],
    );
  }
}
