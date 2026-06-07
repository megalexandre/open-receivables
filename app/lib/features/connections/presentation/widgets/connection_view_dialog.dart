import 'package:flutter/material.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';
import 'package:organizagrana/shared/utils/app_formats.dart';
import 'package:organizagrana/shared/widgets/data_display/yes_no_badge.dart';
import 'package:organizagrana/shared/widgets/overlay/app_dialog.dart';

Future<void> showConnectionViewDialog(
        BuildContext context, Connection connection) =>
    showAppDialog<void>(
      context: context,
      builder: (_) => _ConnectionViewDialog(connection: connection),
    );

class _ConnectionViewDialog extends StatelessWidget {
  const _ConnectionViewDialog({required this.connection});

  final Connection connection;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Detalhes da Ligação',
      content: _DetailTable(connection: connection),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

class _DetailTable extends StatelessWidget {
  const _DetailTable({required this.connection});

  final Connection connection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        _Row(label: 'Sócio', labelStyle: labelStyle, child: Text(connection.memberName)),
        _Row(label: 'Endereço', labelStyle: labelStyle, child: Text(connection.address)),
        _Row(
          label: 'Status',
          labelStyle: labelStyle,
          child: YesNoBadge(value: connection.active),
        ),
        _Row(
          label: 'Categoria',
          labelStyle: labelStyle,
          child: Text(connection.categoryName),
        ),
        _Row(
          label: 'Valor',
          labelStyle: labelStyle,
          child: Text(currencyFormat.format(connection.value)),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.labelStyle,
    required this.child,
  });

  final String label;
  final TextStyle? labelStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: labelStyle)),
          Expanded(child: child),
        ],
      ),
    );
  }
}
