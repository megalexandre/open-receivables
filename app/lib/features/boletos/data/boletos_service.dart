import 'package:organizagrana/features/boletos/data/boletos_api_client.dart';
import 'package:organizagrana/features/boletos/domain/boleto.dart';
import 'package:organizagrana/features/boletos/domain/boleto_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

class BoletosResult {
  const BoletosResult({
    required this.boletos,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<Boleto> boletos;
  final int total;
  final int page;
  final int pageSize;
}

class BoletosService {
  BoletosService({required BoletosApiClient apiClient})
      : _apiClient = apiClient;

  final BoletosApiClient _apiClient;

  Future<BoletosResult> list({
    int page = 1,
    int pageSize = 10,
    String? sortBy,
    bool sortAscending = true,
    BoletoFilter filter = const BoletoFilter(),
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
        filter: filter,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      return BoletosResult(
        boletos: data.map(Boleto.fromJson).toList(),
        total: (json['total'] as num).toInt(),
        page: (json['page'] as num).toInt(),
        pageSize: (json['pageSize'] as num).toInt(),
      );
    } on AppFailure catch (e) {
      throw BoletoFailure(e.type);
    }
  }

  Future<Boleto> create(Boleto boleto) async {
    try {
      final json = await _apiClient.create(boleto);
      return Boleto.fromJson(json);
    } on AppFailure catch (e) {
      throw BoletoFailure(e.type);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete(id);
    } on AppFailure catch (e) {
      throw BoletoFailure(e.type);
    }
  }
}
