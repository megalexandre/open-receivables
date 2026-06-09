import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class CaixaApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 50,
    String? sortBy,
    bool sortAscending = false,
    String? startDate,
    String? endDate,
    String? paymentMethod,
  });
}

class HttpCaixaApiClient extends BaseHttpResourceClient
    implements CaixaApiClient {
  HttpCaixaApiClient({required HttpApiClient httpClient}) : super(httpClient);

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 50,
    String? sortBy,
    bool sortAscending = false,
    String? startDate,
    String? endDate,
    String? paymentMethod,
  }) {
    final uri = Uri.parse(ApiEndpoints.caixa.list).replace(
      queryParameters: {
        ...listParams(page, pageSize, sortBy, sortAscending),
        'startDate': ?startDate,
        'endDate': ?endDate,
        'paymentMethod': ?paymentMethod,
      },
    );
    return call(() => httpClient.getJson(uri));
  }
}
