import 'package:intl/intl.dart';
import 'package:organizagrana/features/caixa/data/caixa_api_client.dart';
import 'package:organizagrana/features/caixa/domain/caixa_failure.dart';
import 'package:organizagrana/features/caixa/domain/caixa_posting.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

final _dateFmt = DateFormat('yyyy-MM-dd');

class CaixaResult {
  const CaixaResult({
    required this.postings,
    required this.total,
    required this.totalValue,
    required this.page,
    required this.pageSize,
  });

  final List<CaixaPosting> postings;
  final int total;
  final double totalValue;
  final int page;
  final int pageSize;
}

class CaixaService {
  CaixaService({required CaixaApiClient apiClient}) : _apiClient = apiClient;

  final CaixaApiClient _apiClient;

  Future<CaixaResult> list({
    int page = 1,
    int pageSize = 50,
    String? sortBy,
    bool sortAscending = false,
    CaixaFilter filter = const CaixaFilter(),
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
        startDate:
            filter.startDate != null ? _dateFmt.format(filter.startDate!) : null,
        endDate:
            filter.endDate != null ? _dateFmt.format(filter.endDate!) : null,
        paymentMethod: filter.paymentMethod?.label,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      return CaixaResult(
        postings: data.map(CaixaPosting.fromJson).toList(),
        total: (json['total'] as num).toInt(),
        totalValue: (json['total_value'] as num).toDouble(),
        page: (json['page'] as num).toInt(),
        pageSize: (json['pageSize'] as num).toInt(),
      );
    } on AppFailure catch (e) {
      throw CaixaFailure(e.type);
    }
  }
}
