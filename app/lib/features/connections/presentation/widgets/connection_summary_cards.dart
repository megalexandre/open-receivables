import 'package:flutter/material.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';

class ConnectionSummaryCards extends StatelessWidget {
  const ConnectionSummaryCards({super.key, required this.summary});

  final ConnectionSummary summary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Total de Ligações',
            value: '${summary.total}',
            icon: Icons.people_alt_outlined,
            iconColor: cs.primary,
            progress: 1.0,
            progressColor: cs.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            label: 'Ligações Ativas',
            value: '${summary.active}',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
            progress: summary.total > 0 ? summary.active / summary.total : 0,
            progressColor: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            label: 'Nº Clientes Efetivos/Temporários',
            value: '${summary.effective}/${summary.temporary}',
            icon: Icons.person_add_alt_1_outlined,
            iconColor: cs.tertiary,
            progress: summary.total > 0
                ? (summary.effective + summary.temporary) / summary.total
                : 0,
            progressColor: cs.tertiary,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.progress,
    required this.progressColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final double progress;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              color: progressColor,
              backgroundColor: progressColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
