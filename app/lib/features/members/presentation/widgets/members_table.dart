import 'package:flutter/material.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/widgets/data_display/app_table.dart';
import 'package:organizagrana/shared/widgets/data_display/document_text.dart';
import 'package:organizagrana/shared/widgets/data_display/yes_no_badge.dart';

class MembersTable extends StatelessWidget {
  const MembersTable({
    super.key,
    required this.members,
    required this.onEdit,
    required this.onDelete,
    required this.onReactivate,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.loading = false,
    this.onLoadMore,
    this.hasMore = false,
  });

  final List<Member> members;
  final void Function(Member) onEdit;
  final void Function(Member) onDelete;
  final void Function(Member) onReactivate;
  final void Function(String key, bool ascending)? onSort;
  final String? sortKey;
  final bool sortAscending;
  final bool loading;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return AppTable<Member>(
      items: members,
      total: members.length,
      page: 1,
      pageSize: members.length,
      onPageChanged: (_) {},
      striped: true,
      onSort: onSort,
      sortKey: sortKey,
      sortAscending: sortAscending,
      loading: loading,
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      columns: [
        AppTableColumn(
          label: 'Nome',
          sortKey: 'name',
          flex: 7,
          builder: (m) => Text(m.name),
        ),
        AppTableColumn(
          label: 'Documento',
          builder: (m) => DocumentText(m.document),
        ),
        AppTableColumn(
          label: 'Número',
          sortKey: 'member_number',
          builder: (m) => Text(m.memberNumber?.toString() ?? ''),
        ),
        AppTableColumn(
          label: 'Votante',
          builder: (m) => YesNoBadge(value: m.voter),
        ),
        AppTableColumn(
          label: 'Ações',
          showInCard: false,
          builder: (m) => Row(
            mainAxisSize: MainAxisSize.min,
            children: m.active
                ? [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      tooltip: 'Editar',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onEdit(m),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      tooltip: 'Excluir',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onDelete(m),
                    ),
                  ]
                : [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      tooltip: 'Visualizar',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onEdit(m),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.restore, size: 16),
                      tooltip: 'Reativar',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onReactivate(m),
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}
