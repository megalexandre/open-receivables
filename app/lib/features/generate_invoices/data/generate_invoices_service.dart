import 'package:organizagrana/features/generate_invoices/data/generate_invoices_api_client.dart';
import 'package:organizagrana/features/generate_invoices/domain/generate_invoices_failure.dart';
import 'package:organizagrana/features/generate_invoices/domain/invoice_candidate.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

class InvoiceCandidatesResult {
  const InvoiceCandidatesResult({
    required this.candidates,
    required this.total,
    required this.totalValue,
  });
  final List<InvoiceCandidate> candidates;
  final int total;
  final double totalValue;
}

class GenerateInvoicesService {
  GenerateInvoicesService({required this.apiClient});

  final GenerateInvoicesApiClient apiClient;

  Future<InvoiceCandidatesResult> listCandidates({
    InvoiceCandidateFilter filter = const InvoiceCandidateFilter(),
  }) async {
    try {
      final json = await apiClient.listCandidates(filter: filter);
      final data = json['data'] as List<dynamic>;
      return InvoiceCandidatesResult(
        candidates: data
            .map((e) => InvoiceCandidate.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        totalValue: (json['total_value'] as num).toDouble(),
      );
    } on AppFailure catch (e) {
      throw GenerateInvoicesFailure(e.message);
    }
  }

  Future<void> generate(GenerateInvoicesRequest request) async {
    try {
      await apiClient.generate(request);
    } on AppFailure catch (e) {
      throw GenerateInvoicesFailure(e.message);
    }
  }
}
