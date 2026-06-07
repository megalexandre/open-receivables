import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class AddressesApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  });
  Future<Map<String, dynamic>> create(Address address);
  Future<Map<String, dynamic>> update(Address address);
  Future<void> delete(String id);
}

class HttpAddressesApiClient extends BaseHttpResourceClient
    implements AddressesApiClient {
  HttpAddressesApiClient({required HttpApiClient httpClient})
      : super(httpClient);

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  }) {
    final uri = Uri.parse(ApiEndpoints.addresses.list)
        .replace(queryParameters: listParams(page, pageSize, sortBy, sortAscending));
    return call(() => httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> create(Address address) => call(
        () => httpClient.postJson(
          Uri.parse(ApiEndpoints.addresses.create),
          address.toJson()..remove('id'),
        ),
      );

  @override
  Future<Map<String, dynamic>> update(Address address) => call(
        () => httpClient.putJson(
          Uri.parse(ApiEndpoints.addresses.byId(address.id)),
          address.toJson(),
        ),
      );

  @override
  Future<void> delete(String id) => callVoid(
        () => httpClient.deleteVoid(Uri.parse(ApiEndpoints.addresses.byId(id))),
      );
}
