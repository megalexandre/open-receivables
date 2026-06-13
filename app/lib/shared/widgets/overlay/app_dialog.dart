import 'dart:ui';

import 'package:flutter/material.dart';

/// Abre um dialog com backdrop desfocado e escurecido.
/// O [builder] recebe o context e deve retornar um [AppDialog].
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 180),
    transitionBuilder: (ctx, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
    pageBuilder: (ctx, _, _) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: builder(ctx),
    ),
  );
}

/// Shell de dialog padronizado: fundo branco, cantos retos, título + X + conteúdo + ações.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.width = 420,
    this.contentPadding = const EdgeInsets.fromLTRB(24, 0, 24, 0),
  });

  final String title;
  final Widget content;
  final List<Widget> actions;
  final double width;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Dialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: cs.surfaceContainerLowest,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 8, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.headlineSmall),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: contentPadding,
                child: content,
              ),
            ),
            if (actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions
                      .expand((w) => [w, const SizedBox(width: 8)])
                      .toList()
                    ..removeLast(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
