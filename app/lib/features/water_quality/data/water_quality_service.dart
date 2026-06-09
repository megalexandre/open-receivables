import 'package:organizagrana/features/water_quality/data/water_quality_api_client.dart';
import 'package:organizagrana/features/water_quality/domain/water_analysis.dart';
import 'package:organizagrana/features/water_quality/domain/water_quality_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

class WaterQualityResult {
  const WaterQualityResult({
    required this.analyses,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<WaterAnalysis> analyses;
  final int total;
  final int page;
  final int pageSize;
}

class WaterQualityService {
  WaterQualityService({required WaterQualityApiClient apiClient})
      : _apiClient = apiClient;

  final WaterQualityApiClient _apiClient;

  Future<WaterQualityResult> list({
    int page = 1,
    int pageSize = 10,
    String? sortBy,
    bool sortAscending = true,
    String? reference,
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
        reference: reference,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      final pagination = json['pagination'] as Map<String, dynamic>;
      return WaterQualityResult(
        analyses: data.map(WaterAnalysis.fromJson).toList(),
        total: (pagination['total_count'] as num).toInt(),
        page: (pagination['current_page'] as num).toInt(),
        pageSize: (pagination['per_page'] as num).toInt(),
      );
    } on AppFailure catch (e) {
      throw WaterQualityFailure(e.type);
    }
  }

  Future<void> create(WaterAnalysisBatch batch) async {
    try {
      await _apiClient.create(batch);
    } on AppFailure catch (e) {
      throw WaterQualityFailure(e.type);
    }
  }

  Future<void> delete(String reference) async {
    try {
      await _apiClient.delete(reference);
    } on AppFailure catch (e) {
      throw WaterQualityFailure(e.type);
    }
  }
}
