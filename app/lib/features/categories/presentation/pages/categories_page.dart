import 'package:flutter/material.dart';
import 'package:organizagrana/features/categories/data/categories_service.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/categories/domain/category_failure.dart';
import 'package:organizagrana/features/categories/presentation/widgets/categories_table.dart';
import 'package:organizagrana/features/categories/presentation/widgets/category_dialog/category_delete_dialog.dart';
import 'package:organizagrana/features/categories/presentation/widgets/category_dialog/category_form_dialog.dart';
import 'package:organizagrana/features/categories/presentation/widgets/category_filter_bar.dart';
import 'package:organizagrana/shared/widgets/form/clear_filters_on_escape.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, required this.service});

  final CategoriesService service;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _filterBarKey = GlobalKey<CategoryFilterBarState>();
  List<Category> _categories = [];
  int _total = 0;
  int _page = 1;
  static const int _pageSize = 20;
  String? _sortBy;
  bool _sortAscending = true;
  bool _loading = false;
  bool _hasMore = false;
  String? _error;
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
        pageSize: _pageSize,
        sortBy: _sortBy,
        sortAscending: _sortAscending,
        active: _filterActive,
      );
      if (mounted) {
        setState(() {
          _categories = [..._categories, ...result.categories];
          _total = result.total;
          _hasMore = _categories.length < _total;
          _page++;
          _loading = false;
        });
      }
    } on CategoryFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  void _reset() {
    _categories = [];
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

  void _onFilter({bool? active}) {
    setState(() {
      _filterActive = active;
      _reset();
    });
    _loadMore();
  }

  Future<void> _openForm([Category? category]) async {
    final saved = await showCategoryFormDialog(
      context,
      category: category,
      onSave: category == null
          ? (result) => widget.service.create(result)
          : (result) => widget.service.update(result),
      onReactivate: (result) async {
        await widget.service.reactivate(result.id);
      },
    );
    if (saved) _refresh();
  }

  Future<void> _reactivate(Category category) async {
    try {
      await widget.service.reactivate(category.id);
      _refresh();
    } on CategoryFailure catch (e) {
      if (mounted) _showError(e.message);
    }
  }

  Future<void> _confirmDelete(Category category) async {
    final confirmed = await showCategoryDeleteDialog(context, category);
    if (!confirmed) return;

    try {
      await widget.service.delete(category.id);
      _refresh();
    } on CategoryFailure catch (e) {
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
    return ClearFiltersOnEscape(
      onClear: () => _filterBarKey.currentState?.clear(),
      child: Padding(
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
                      'Categorias',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Gerencie e organize as categorias de contas.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nova Categoria'),
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
                      CategoryFilterBar(
                        key: _filterBarKey,
                        onFilter: _onFilter,
                      ),
                      Expanded(
                        child: CategoriesTable(
                          categories: _categories,
                          onSort: _onSort,
                          sortKey: _sortBy,
                          sortAscending: _sortAscending,
                          onEdit: _openForm,
                          onDelete: _confirmDelete,
                          onReactivate: _reactivate,
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
      ),
    );
  }
}
