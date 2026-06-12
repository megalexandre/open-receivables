import 'package:organizagrana/features/categories/data/categories_api_client.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/categories/domain/category_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

export 'package:organizagrana/shared/errors/app_failure.dart'
    show ValidationFailure, ApiValidationError;

class CategoriesResult {
  const CategoriesResult({
    required this.categories,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<Category> categories;
  final int total;
  final int page;
  final int pageSize;
}

class CategoriesService {
  CategoriesService({required CategoriesApiClient apiClient})
      : _apiClient = apiClient;

  final CategoriesApiClient _apiClient;

  Future<CategoriesResult> list({
    int page = 1,
    required int pageSize,
    String? sortBy,
    bool sortAscending = true,
    bool? active,
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
        active: active,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      final pagination = json['pagination'] as Map<String, dynamic>;
      return CategoriesResult(
        categories: data.map(Category.fromJson).toList(),
        total: (pagination['total_count'] as num).toInt(),
        page: (pagination['current_page'] as num).toInt(),
        pageSize: (pagination['per_page'] as num).toInt(),
      );
    } on AppFailure catch (e) {
      throw CategoryFailure(e.type);
    }
  }

  Future<Category> create(Category category) async {
    try {
      final json = await _apiClient.create(category);
      return Category.fromJson(json);
    } on ValidationFailure {
      rethrow;
    } on AppFailure catch (e) {
      throw CategoryFailure(e.type);
    }
  }

  Future<Category> update(Category category) async {
    try {
      final json = await _apiClient.update(category);
      return Category.fromJson(json);
    } on ValidationFailure {
      rethrow;
    } on AppFailure catch (e) {
      throw CategoryFailure(e.type);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete(id);
    } on AppFailure catch (e) {
      throw CategoryFailure(e.type);
    }
  }

  Future<Category> reactivate(String id) async {
    try {
      final json = await _apiClient.reactivate(id);
      return Category.fromJson(json);
    } on AppFailure catch (e) {
      throw CategoryFailure(e.type);
    }
  }
}
