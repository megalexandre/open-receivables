import 'package:organizagrana/features/categories/domain/category.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class CategoriesApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
    bool? active,
  });
  Future<Map<String, dynamic>> create(Category category);
  Future<Map<String, dynamic>> update(Category category);
  Future<void> delete(String id);
  Future<Map<String, dynamic>> reactivate(String id);
}


class HttpCategoriesApiClient extends BaseHttpResourceClient
    implements CategoriesApiClient {
  HttpCategoriesApiClient({required HttpApiClient httpClient})
      : super(httpClient);

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
    bool? active,
  }) {
    final uri = Uri.parse(ApiEndpoints.categories.list).replace(
      queryParameters: {
        'page': '$page',
        'limit': '$pageSize',
        if (sortBy != null) 'sort_by': sortBy,
        if (sortBy != null) 'sort_order': sortAscending ? 'asc' : 'desc',
        if (active != null) 'active': '$active',
      },
    );
    return call(() => httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> create(Category category) => call(
        () => httpClient.postJson(
          Uri.parse(ApiEndpoints.categories.create),
          category.toJson()..remove('id'),
        ),
      );

  @override
  Future<Map<String, dynamic>> update(Category category) => call(
        () => httpClient.putJson(
          Uri.parse(ApiEndpoints.categories.byId(category.id)),
          category.toJson(),
        ),
      );

  @override
  Future<void> delete(String id) => callVoid(
        () => httpClient.deleteVoid(Uri.parse(ApiEndpoints.categories.byId(id))),
      );

  @override
  Future<Map<String, dynamic>> reactivate(String id) => call(
        () => httpClient.patchJson(
          Uri.parse(ApiEndpoints.categories.reactivate(id)),
          const {},
        ),
      );
}
