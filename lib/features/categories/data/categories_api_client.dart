import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/features/categories/domain/category_failure.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class CategoriesApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  });
  Future<Map<String, dynamic>> create(Category category);
  Future<Map<String, dynamic>> update(Category category);
  Future<void> delete(String id);
}

class CategoryApiClientException implements Exception {
  const CategoryApiClientException(this.type);

  final AppFailureType type;

  @override
  String toString() => CategoryFailure(type).message;
}

class HttpCategoriesApiClient implements CategoriesApiClient {
  HttpCategoriesApiClient({required HttpApiClient httpClient})
      : _httpClient = httpClient;

  final HttpApiClient _httpClient;

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  }) {
    final params = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (sortBy != null) 'sortBy': sortBy,
      if (sortBy != null) 'sortOrder': sortAscending ? 'asc' : 'desc',
    };
    final uri = Uri.parse(ApiEndpoints.categories.list)
        .replace(queryParameters: params);
    return _call(() => _httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> create(Category category) {
    return _call(
      () => _httpClient.postJson(
        Uri.parse(ApiEndpoints.categories.create),
        category.toJson()..remove('id'),
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> update(Category category) {
    return _call(
      () => _httpClient.putJson(
        Uri.parse(ApiEndpoints.categories.byId(category.id)),
        category.toJson(),
      ),
    );
  }

  @override
  Future<void> delete(String id) {
    return _callVoid(
      () => _httpClient.deleteVoid(
        Uri.parse(ApiEndpoints.categories.byId(id)),
      ),
    );
  }

  Future<Map<String, dynamic>> _call(
    Future<Map<String, dynamic>> Function() fn,
  ) async {
    try {
      return await fn();
    } on ApiException catch (e) {
      throw CategoryApiClientException(_mapFailure(e.type));
    }
  }

  Future<void> _callVoid(Future<void> Function() fn) async {
    try {
      return await fn();
    } on ApiException catch (e) {
      throw CategoryApiClientException(_mapFailure(e.type));
    }
  }

  AppFailureType _mapFailure(ApiFailureType type) => switch (type) {
        ApiFailureType.network => AppFailureType.network,
        ApiFailureType.unauthorized => AppFailureType.server,
        ApiFailureType.server => AppFailureType.server,
        ApiFailureType.invalidResponse => AppFailureType.invalidResponse,
      };
}
