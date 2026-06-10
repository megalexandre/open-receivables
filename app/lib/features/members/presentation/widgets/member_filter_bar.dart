import 'package:flutter/material.dart';

class MemberFilterBar extends StatefulWidget {
  const MemberFilterBar({super.key, required this.onFilter});

  final void Function({String? name, String? document, bool? active}) onFilter;

  @override
  State<MemberFilterBar> createState() => _MemberFilterBarState();
}

class _MemberFilterBarState extends State<MemberFilterBar> {
  final _nameCtrl = TextEditingController();
  final _documentCtrl = TextEditingController();
  bool? _active;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _documentCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    final name = _nameCtrl.text.trim();
    widget.onFilter(
      name: name.length >= 4 ? name : null,
      document: _documentCtrl.text.trim().isEmpty ? null : _documentCtrl.text.trim(),
      active: _active,
    );
  }

  void _clear() {
    setState(() {
      _nameCtrl.clear();
      _documentCtrl.clear();
      _active = null;
    });
    widget.onFilter(name: null, document: null, active: null);
  }

  bool get _hasFilters =>
      _nameCtrl.text.isNotEmpty || _documentCtrl.text.isNotEmpty || _active != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Nome...',
                isDense: true,
                prefixIcon: Icon(Icons.search, size: 16),
              ),
              onSubmitted: (_) => _notify(),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _documentCtrl,
              decoration: const InputDecoration(
                hintText: 'Documento...',
                isDense: true,
                prefixIcon: Icon(Icons.badge_outlined, size: 16),
              ),
              onSubmitted: (_) => _notify(),
            ),
          ),
          const Spacer(),
          if (_hasFilters)
            TextButton(
              onPressed: _clear,
              child: const Text('Limpar'),
            ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _notify,
            icon: const Icon(Icons.search, size: 16),
            label: const Text('Consultar'),
          ),
        ],
      ),
    );
  }
}
