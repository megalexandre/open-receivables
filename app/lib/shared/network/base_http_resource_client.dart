import 'package:organizagrana/shared/errors/app_failure.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

export 'package:organizagrana/shared/errors/app_failure.dart'
    show ValidationFailure;

abstract class BaseHttpResourceClient {
  const BaseHttpResourceClient(this.httpClient);

  final HttpApiClient httpClient;

  Map<String, String> listParams(int page, int pageSize, String? sortBy, bool sortAscending) => {
        'page': '$page',
        'pageSize': '$pageSize',
        if (sortBy != null) 'sortBy': sortBy,
        if (sortBy != null) 'sortOrder': sortAscending ? 'asc' : 'desc',
      };

  Future<Map<String, dynamic>> call(Future<Map<String, dynamic>> Function() fn) async {
    try {
      return await fn();
    } on ApiValidationException catch (e) {
      throw ValidationFailure(e.errors);
    } on ApiException catch (e) {
      throw AppFailure(mapFailure(e.type));
    }
  }

  Future<void> callVoid(Future<void> Function() fn) async {
    try {
      return await fn();
    } on ApiValidationException catch (e) {
      throw ValidationFailure(e.errors);
    } on ApiException catch (e) {
      throw AppFailure(mapFailure(e.type));
    }
  }

  AppFailureType mapFailure(ApiFailureType type) => switch (type) {
        ApiFailureType.network => AppFailureType.network,
        ApiFailureType.unauthorized => AppFailureType.server,
        ApiFailureType.server => AppFailureType.server,
        ApiFailureType.invalidResponse => AppFailureType.invalidResponse,
        ApiFailureType.validation => AppFailureType.validation,
      };
}
