import 'package:flutter/material.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';
import 'package:organizagrana/shared/widgets/data_display/yes_no_badge.dart';

class MembersTable extends StatelessWidget {
  const MembersTable({
    super.key,
    required this.members,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    required this.onEdit,
    required this.onDelete,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
  });

  final List<Member> members;
  final int total;
  final int page;
  final int pageSize;
  final void Function(int page) onPageChanged;
  final void Function(Member) onEdit;
  final void Function(Member) onDelete;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AppTable<Member>(
      items: members,
      total: total,
      page: page,
      pageSize: pageSize,
      onPageChanged: onPageChanged,
      striped: true,
      onSort: onSort,
      sortKey: sortKey,
      sortAscending: sortAscending,
      loading: loading,
      columns: [
        AppTableColumn(
          label: 'Número',
          sortKey: 'memberNumber',
          builder: (m) => Text(m.memberNumber),
        ),
        AppTableColumn(
          label: 'Nome',
          sortKey: 'name',
          builder: (m) => Text(m.name),
        ),
        AppTableColumn(
          label: 'Documento',
          sortKey: 'document',
          builder: (m) => Text(m.document),
        ),
        AppTableColumn(
          label: 'Ativo',
          sortKey: 'active',
          builder: (m) => YesNoBadge(value: m.active),
        ),
        AppTableColumn(
          label: 'Ações',
          showInCard: false,
          builder: (m) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Editar',
                onPressed: () => onEdit(m),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                tooltip: 'Excluir',
                onPressed: () => onDelete(m),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
