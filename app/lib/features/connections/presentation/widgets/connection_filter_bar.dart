import 'package:flutter/material.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/widgets/form/member_autocomplete.dart';

class ConnectionFilterBar extends StatefulWidget {
  const ConnectionFilterBar({
    super.key,
    required this.onFilter,
    required this.searchMembers,
  });

  final void Function({String? memberId, String? address, bool? active}) onFilter;
  final Future<List<Member>> Function(String query) searchMembers;

  @override
  State<ConnectionFilterBar> createState() => ConnectionFilterBarState();
}

class ConnectionFilterBarState extends State<ConnectionFilterBar> {
  Member? _memberFilter;
  bool? _activeFilter;

  void clear() {
    setState(() {
      _memberFilter = null;
      _activeFilter = null;
    });
    _query();
  }

  void _query() {
    widget.onFilter(
      memberId: _memberFilter?.id,
      address: null,
      active: _activeFilter,
    );
  }

  bool get _hasFilters => _memberFilter != null || _activeFilter != null;

  @override
  Widget build(BuildContext context) {
    final memberField = MemberAutocomplete(
      search: widget.searchMembers,
      onChanged: (member) {
        setState(() => _memberFilter = member);
      },
      initialValue: _memberFilter,
    );

    final statusField = DropdownButtonFormField<bool?>(
      initialValue: _activeFilter,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Status',
        isDense: true,
      ),
      items: const [
        DropdownMenuItem(child: Text('Todos')),
        DropdownMenuItem(value: true, child: Text('Ativos')),
        DropdownMenuItem(value: false, child: Text('Inativos')),
      ],
      onChanged: (v) {
        setState(() => _activeFilter = v);
      },
    );

    final actions = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 8,
      children: [
        if (_hasFilters)
          TextButton(onPressed: clear, child: const Text('Limpar')),
        FilledButton.icon(
          onPressed: _query,
          icon: const Icon(Icons.search, size: 16),
          label: const Text('Consultar'),
        ),
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return Column(
                spacing: 12,
                children: [
                  Column(spacing: 12, children: [memberField, statusField]),
                  actions,
                ],
              );
            }
            return Column(
              spacing: 12,
              children: [
                Row(
                  spacing: 12,
                  children: [
                    Expanded(flex: 2, child: memberField),
                    Expanded(child: statusField),
                  ],
                ),
                actions,
              ],
            );
          },
        ),
      ),
    );
  }
}
