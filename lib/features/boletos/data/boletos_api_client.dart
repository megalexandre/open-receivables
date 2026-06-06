import 'package:organizagrana/features/boletos/domain/boleto.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class BoletosApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 10,
    String? sortBy,
    bool sortAscending = true,
    BoletoFilter filter = const BoletoFilter(),
  });
  Future<Map<String, dynamic>> create(Boleto boleto);
  Future<void> delete(String id);
}

class HttpBoletosApiClient extends BaseHttpResourceClient
    implements BoletosApiClient {
  HttpBoletosApiClient({required HttpApiClient httpClient})
      : super(httpClient);

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 10,
    String? sortBy,
    bool sortAscending = true,
    BoletoFilter filter = const BoletoFilter(),
  }) {
    final params = {
      ...listParams(page, pageSize, sortBy, sortAscending),
      ...filter.toQueryParams(),
    };
    final uri = Uri.parse(ApiEndpoints.boletos.list)
        .replace(queryParameters: params);
    return call(() => httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> create(Boleto boleto) => call(
        () => httpClient.postJson(
          Uri.parse(ApiEndpoints.boletos.create),
          boleto.toJson()..remove('id'),
        ),
      );

  @override
  Future<void> delete(String id) => callVoid(
        () => httpClient.deleteVoid(
            Uri.parse(ApiEndpoints.boletos.byId(id))),
      );
}
