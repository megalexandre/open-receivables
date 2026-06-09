import 'package:organizagrana/features/generate_invoices/domain/invoice_candidate.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/base_http_resource_client.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class GenerateInvoicesApiClient {
  Future<Map<String, dynamic>> listCandidates({
    InvoiceCandidateFilter filter,
  });
  Future<void> generate(GenerateInvoicesRequest request);
}

class HttpGenerateInvoicesApiClient extends BaseHttpResourceClient
    implements GenerateInvoicesApiClient {
  HttpGenerateInvoicesApiClient({required HttpApiClient httpClient})
      : super(httpClient);

  @override
  Future<Map<String, dynamic>> listCandidates({
    InvoiceCandidateFilter filter = const InvoiceCandidateFilter(),
  }) {
    final uri = Uri.parse(ApiEndpoints.generateInvoices.candidates)
        .replace(queryParameters: filter.toQueryParams());
    return call(() => httpClient.getJson(uri));
  }

  @override
  Future<void> generate(GenerateInvoicesRequest request) => callVoid(
        () => httpClient.postJson(
          Uri.parse(ApiEndpoints.generateInvoices.generate),
          request.toJson(),
        ),
      );
}
