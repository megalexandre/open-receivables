import 'package:organizagrana/features/water_quality/domain/water_analysis.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class WaterQualityApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 10,
    String? sortBy,
    bool sortAscending = true,
    String? reference,
  });
  Future<Map<String, dynamic>> create(WaterAnalysisBatch batch);
}

class HttpWaterQualityApiClient extends BaseHttpResourceClient
    implements WaterQualityApiClient {
  HttpWaterQualityApiClient({required HttpApiClient httpClient})
      : super(httpClient);

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 10,
    String? sortBy,
    bool sortAscending = true,
    String? reference,
  }) {
    final uri = Uri.parse(ApiEndpoints.waterQuality.list).replace(
      queryParameters: {
        ...listParams(page, pageSize, sortBy, sortAscending),
        'reference': ?reference,
      },
    );
    return call(() => httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> create(WaterAnalysisBatch batch) => call(
        () => httpClient.postJson(
          Uri.parse(ApiEndpoints.waterQuality.create),
          batch.toJson(),
        ),
      );
}
