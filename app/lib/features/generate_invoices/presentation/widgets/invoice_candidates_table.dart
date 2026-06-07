import 'package:flutter/material.dart';
import 'package:organizagrana/features/generate_invoices/domain/invoice_candidate.dart';
import 'package:organizagrana/shared/widgets/data_display/money_text.dart';

class InvoiceCandidatesTable extends StatelessWidget {
  const InvoiceCandidatesTable({
    super.key,
    required this.candidates,
    required this.selected,
    required this.onToggle,
    required this.onToggleAll,
    required this.loading,
  });

  final List<InvoiceCandidate> candidates;
  final Set<String> selected;
  final void Function(String id, bool value) onToggle;
  final void Function(bool value) onToggleAll;
  final bool loading;

  static const _columns = [
    ('memberName', 'SÓCIO', 3.0),
    ('address', 'ENDEREÇO', 2.5),
    ('category', 'CATEGORIA', 1.5),
    ('valorTotal', 'VALOR TOTAL', 1.2),
    ('hdrInicial', 'HDR. INICIAL', 1.2),
  ];

  bool get _allSelected =>
      candidates.isNotEmpty && candidates.every((c) => selected.contains(c.id));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Checkbox(
                  value: _allSelected,
                  tristate: selected.isNotEmpty && !_allSelected,
                  onChanged: (v) => onToggleAll(v ?? false),
                ),
              ),
              ..._columns.map(
                (col) => Expanded(
                  flex: (col.$3 * 10).toInt(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: Text(col.$2, style: headerStyle),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : candidates.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum candidato encontrado.',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  itemCount: candidates.length,
                  itemBuilder: (context, i) {
                    final c = candidates[i];
                    final isSelected = selected.contains(c.id);
                    return _CandidateRow(
                      candidate: c,
                      selected: isSelected,
                      onToggle: (v) => onToggle(c.id, v),
                      isEven: i.isEven,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CandidateRow extends StatelessWidget {
  const _CandidateRow({
    required this.candidate,
    required this.selected,
    required this.onToggle,
    required this.isEven,
  });

  final InvoiceCandidate candidate;
  final bool selected;
  final void Function(bool) onToggle;
  final bool isEven;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isEven
            ? theme.colorScheme.surfaceContainerLowest
            : theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Checkbox(
              value: selected,
              onChanged: (v) => onToggle(v ?? false),
            ),
          ),
          Expanded(flex: 30, child: _cell(context, candidate.memberName)),
          Expanded(flex: 25, child: _cell(context, candidate.address)),
          Expanded(flex: 15, child: _cell(context, candidate.category)),
          Expanded(
            flex: 12,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: MoneyText(candidate.valorTotal),
            ),
          ),
          Expanded(
            flex: 12,
            child: _cell(context, candidate.hdrInicial.toStringAsFixed(1)),
          ),
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
