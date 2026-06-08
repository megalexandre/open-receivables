import 'package:flutter/material.dart';
import 'package:organizagrana/features/members/data/members_service.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/features/members/domain/member_failure.dart';
import 'package:organizagrana/features/members/presentation/widgets/member_delete_dialog.dart';
import 'package:organizagrana/features/members/presentation/widgets/member_filter_bar.dart';
import 'package:organizagrana/features/members/presentation/widgets/member_form_dialog.dart';
import 'package:organizagrana/features/members/presentation/widgets/members_table.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key, required this.service});

  final MembersService service;

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  List<Member> _members = [];
  int _total = 0;
  int _page = 1;

  String? _sortBy;
  bool _sortAscending = true;
  bool _loading = false;
  bool _hasMore = false;
  String? _error;
  String? _filterName;
  String? _filterDocument;
  bool? _filterActive;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.service.list(
        page: _page,
        sortBy: _sortBy,
        sortAscending: _sortAscending,
        name: _filterName,
        document: _filterDocument,
        active: _filterActive,
      );
      if (mounted) {
        setState(() {
          _members = [..._members, ...result.members];
          _total = result.total;
          _hasMore = _members.length < _total;
          _page++;
          _loading = false;
        });
      }
    } on MemberFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  void _reset() {
    _members = [];
    _page = 1;
    _hasMore = false;
    _loading = false;
  }

  void _refresh() {
    setState(_reset);
    _loadMore();
  }

  void _onSort(String key, bool ascending) {
    setState(() {
      _sortBy = key;
      _sortAscending = ascending;
      _reset();
    });
    _loadMore();
  }

  void _onFilter({String? name, String? document, bool? active}) {
    setState(() {
      _filterName = name;
      _filterDocument = document;
      _filterActive = active;
      _reset();
    });
    _loadMore();
  }

  Future<void> _openForm([Member? member]) async {
    final result = await MemberFormDialog.show(context, member);
    if (result == null) return;
    try {
      if (member == null) {
        await widget.service.create(result);
      } else {
        await widget.service.update(result);
      }
      _refresh();
    } on MemberFailure catch (e) {
      if (mounted) _showError(e.message);
    }
  }

  Future<void> _confirmDelete(Member member) async {
    final confirmed = await showMemberDeleteDialog(context, member);
    if (!confirmed) return;
    try {
      await widget.service.delete(member.id);
      _refresh();
    } on MemberFailure catch (e) {
      if (mounted) _showError(e.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sócios',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Gerencie os sócios da cooperativa.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Novo Sócio'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MemberFilterBar(onFilter: _onFilter),
                    Expanded(
                      child: MembersTable(
                        members: _members,
                        onSort: _onSort,
                        sortKey: _sortBy,
                        sortAscending: _sortAscending,
                        onEdit: _openForm,
                        onDelete: _confirmDelete,
                        loading: _loading,
                        onLoadMore: _loadMore,
                        hasMore: _hasMore,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
