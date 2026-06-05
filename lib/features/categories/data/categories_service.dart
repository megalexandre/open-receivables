import 'package:organizagrana/features/categories/data/categories_api_client.dart';
import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/categories/domain/category_failure.dart';

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
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      return CategoriesResult(
        categories: data.map(Category.fromJson).toList(),
        total: (json['total'] as num).toInt(),
        page: (json['page'] as num).toInt(),
        pageSize: (json['pageSize'] as num).toInt(),
      );
    } on CategoryApiClientException catch (e) {
      throw CategoryFailure(e.type);
    }
  }

  Future<Category> create(Category category) async {
    try {
      final json = await _apiClient.create(category);
      return Category.fromJson(json);
    } on CategoryApiClientException catch (e) {
      throw CategoryFailure(e.type);
    }
  }

  Future<Category> update(Category category) async {
    try {
      final json = await _apiClient.update(category);
      return Category.fromJson(json);
    } on CategoryApiClientException catch (e) {
      throw CategoryFailure(e.type);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete(id);
    } on CategoryApiClientException catch (e) {
      throw CategoryFailure(e.type);
    }
  }
}
