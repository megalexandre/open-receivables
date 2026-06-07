import 'package:flutter/material.dart';
import 'package:organizagrana/features/caixa/domain/caixa_posting.dart';
import 'package:organizagrana/shared/utils/app_formats.dart';
import 'package:organizagrana/shared/widgets/data_display/app_pagination.dart';

class CaixaTable extends StatelessWidget {
  const CaixaTable({
    super.key,
    required this.postings,
    required this.total,
    required this.totalValue,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    this.onSort,
    this.sortKey,
    this.sortAscending = false,
    this.loading = false,
  });

  final List<CaixaPosting> postings;
  final int total;
  final double totalValue;
  final int page;
  final int pageSize;
  final void Function(int page) onPageChanged;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;

  static const _columns = [
    _ColDef('Sócio', 'memberName', false),
    _ColDef('Número', 'number', false),
    _ColDef('Data de Pagamento', 'paymentDate', false),
    _ColDef('Forma de Pagamento', 'paymentMethod', false),
    _ColDef('Valor', 'value', true),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          color: cs.surfaceContainerHighest,
          child: Row(
            children: _columns.map((c) {
              final isSorted = sortKey == c.key;
              return Expanded(
                flex: c.numeric ? 1 : 2,
                child: InkWell(
                  onTap: onSort != null
                      ? () => onSort!(c.key,
                          isSorted ? !sortAscending : true)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: c.numeric
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          c.label.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        if (isSorted)
                          Icon(
                            sortAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 12,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Body
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: postings.length,
                  itemBuilder: (context, index) {
                    final p = postings[index];
                    final isOdd = index.isOdd;
                    return Container(
                      color: isOdd
                          ? cs.surfaceContainerLowest
                          : cs.surface,
                      child: Row(
                        children: [
                          _Cell(child: Text(p.memberName)),
                          _Cell(child: Text(p.number)),
                          _Cell(child: Text(dateFormat.format(p.paymentDate))),
                          _Cell(child: _PaymentBadge(method: p.paymentMethod)),
                          _Cell(
                            flex: 1,
                            align: CrossAxisAlignment.end,
                            child: Text(
                              currencyFormat.format(p.value),
                              style: const TextStyle(
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        // Footer
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: cs.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Mostrando $total registro(s) encontrados',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                'Total Acumulado:',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(width: 8),
              Text(
                currencyFormat.format(totalValue),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AppPagination(
          total: total,
          page: page,
          pageSize: pageSize,
          onPageChanged: onPageChanged,
        ),
      ],
    );
  }
}

class _ColDef {
  const _ColDef(this.label, this.key, this.numeric);
  final String label;
  final String key;
  final bool numeric;
}

class _Cell extends StatelessWidget {
  const _Cell({required this.child, this.flex = 2, this.align});
  final Widget child;
  final int flex;
  final CrossAxisAlignment? align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: align == CrossAxisAlignment.end
            ? Align(alignment: Alignment.centerRight, child: child)
            : child,
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  const _PaymentBadge({required this.method});
  final PaymentMethod method;

  static const _colors = {
    PaymentMethod.pix: Colors.green,
    PaymentMethod.cash: Colors.teal,
    PaymentMethod.card: Colors.blue,
    PaymentMethod.boleto: Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[method] ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        method.label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
