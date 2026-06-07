import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class MembersApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  });
  Future<Map<String, dynamic>> create(Member member);
  Future<Map<String, dynamic>> update(Member member);
  Future<void> delete(String id);
}


class HttpMembersApiClient extends BaseHttpResourceClient
    implements MembersApiClient {
  HttpMembersApiClient({required HttpApiClient httpClient}) : super(httpClient);

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  }) {
    final uri = Uri.parse(ApiEndpoints.members.list)
        .replace(queryParameters: listParams(page, pageSize, sortBy, sortAscending));
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
}
