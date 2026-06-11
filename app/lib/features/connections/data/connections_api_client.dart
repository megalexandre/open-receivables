import 'package:organizagrana/features/connections/domain/connection.dart';
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
  Future<Map<String, dynamic>> create(Connection connection);
  Future<Map<String, dynamic>> update(Connection connection);
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
        if (address != null && address.isNotEmpty) 'addressId': address,
        if (active != null) 'active': '$active',
      },
    );
    return call(() => httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> create(Connection connection) => call(
        () => httpClient.postJson(
          Uri.parse(ApiEndpoints.connections.create),
          {'connection': connection.toJson()},
        ),
      );

  @override
  Future<Map<String, dynamic>> update(Connection connection) => call(
        () => httpClient.putJson(
          Uri.parse(ApiEndpoints.connections.byId(connection.id)),
          {'connection': connection.toJson()},
        ),
      );

  @override
  Future<void> delete(String id) => callVoid(
        () => httpClient
            .deleteVoid(Uri.parse(ApiEndpoints.connections.byId(id))),
      );
}
