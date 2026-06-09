import 'package:flutter/material.dart';
import 'package:organizagrana/features/boletos/domain/boleto.dart';

class BoletoStatusBadge extends StatelessWidget {
  const BoletoStatusBadge(this.status, {super.key});

  final BoletoStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = switch (status) {
      BoletoStatus.paga => (cs.primaryContainer, cs.onPrimaryContainer),
      BoletoStatus.aberta => (cs.secondaryContainer, cs.onSecondaryContainer),
      BoletoStatus.cancelada => (cs.errorContainer, cs.onErrorContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
