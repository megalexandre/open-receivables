import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class MembersApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 20,
    String? sortBy,
    bool sortAscending = true,
    String? name,
    String? document,
    bool? active,
  });
  Future<Map<String, dynamic>> create(Member member);
  Future<Map<String, dynamic>> update(Member member);
  Future<void> delete(String id);
  Future<Map<String, dynamic>> reactivate(String id);
}


class HttpMembersApiClient extends BaseHttpResourceClient
    implements MembersApiClient {
  HttpMembersApiClient({required HttpApiClient httpClient}) : super(httpClient);

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 20,
    String? sortBy,
    bool sortAscending = true,
    String? name,
    String? document,
    bool? active,
  }) {
    final uri = Uri.parse(ApiEndpoints.members.list).replace(
      queryParameters: {
        'page': '$page',
        'limit': '$pageSize',
        if (sortBy != null) 'sort_by': sortBy,
        if (sortBy != null) 'sort_order': sortAscending ? 'asc' : 'desc',
        if (name != null && name.isNotEmpty) 'name': name,
        if (document != null && document.isNotEmpty) 'document': document,
        if (active != null) 'active': '$active',
      },
    );
    return call(() => httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> create(Member member) => call(
        () => httpClient.postJson(
          Uri.parse(ApiEndpoints.members.create),
          member.toJson()..remove('id'),
        ),
      );

  @override
  Future<Map<String, dynamic>> update(Member member) => call(
        () => httpClient.putJson(
          Uri.parse(ApiEndpoints.members.byId(member.id)),
          member.toJson(),
        ),
      );

  @override
  Future<void> delete(String id) => callVoid(
        () => httpClient.deleteVoid(Uri.parse(ApiEndpoints.members.byId(id))),
      );

  @override
  Future<Map<String, dynamic>> reactivate(String id) => call(
        () => httpClient.patchJson(
          Uri.parse(ApiEndpoints.members.reactivate(id)),
          const {},
        ),
      );
}
