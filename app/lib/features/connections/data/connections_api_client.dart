import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class ConnectionsApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
    String? memberName,
    String? address,
    bool? active,
  });
  Future<Map<String, dynamic>> summary();
  Future<void> delete(String id);
}

class HttpConnectionsApiClient extends BaseHttpResourceClient
    implements ConnectionsApiClient {
  HttpConnectionsApiClient({required HttpApiClient httpClient})
      : super(httpClient);

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
    String? memberName,
    String? address,
    bool? active,
  }) {
    final uri = Uri.parse(ApiEndpoints.connections.list).replace(
      queryParameters: {
        ...listParams(page, pageSize, sortBy, sortAscending),
        if (memberName != null && memberName.isNotEmpty)
          'memberName': memberName,
        if (address != null && address.isNotEmpty) 'address': address,
        if (active != null) 'active': '$active',
      },
    );
    return call(() => httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> summary() => call(
        () => httpClient.getJson(Uri.parse(ApiEndpoints.connections.summary)),
      );

  @override
  Future<void> delete(String id) => callVoid(
        () => httpClient
            .deleteVoid(Uri.parse(ApiEndpoints.connections.byId(id))),
      );
}
