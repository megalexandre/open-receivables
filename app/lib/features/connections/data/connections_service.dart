import 'package:organizagrana/features/connections/data/connections_api_client.dart';
import 'package:organizagrana/features/connections/domain/connection.dart';
import 'package:organizagrana/features/connections/domain/connection_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

class ConnectionsResult {
  const ConnectionsResult({
    required this.connections,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<Connection> connections;
  final int total;
  final int page;
  final int pageSize;
}

class ConnectionsService {
  ConnectionsService({required ConnectionsApiClient apiClient})
      : _apiClient = apiClient;

  final ConnectionsApiClient _apiClient;

  Future<ConnectionsResult> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
    String? memberName,
    String? address,
    bool? active,
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
        memberName: memberName,
        address: address,
        active: active,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      final pagination = json['pagination'] as Map<String, dynamic>;
      return ConnectionsResult(
        connections: data.map(Connection.fromJson).toList(),
        total: (pagination['total_count'] as num).toInt(),
        page: (pagination['current_page'] as num).toInt(),
        pageSize: (pagination['per_page'] as num).toInt(),
      );
    } on AppFailure catch (e) {
      throw ConnectionFailure(e.type);
    }
  }

  Future<ConnectionSummary> summary() async {
    try {
      final json = await _apiClient.summary();
      return ConnectionSummary.fromJson(json);
    } on AppFailure catch (e) {
      throw ConnectionFailure(e.type);
    }
  }

  Future<void> create(Connection connection) async {
    try {
      await _apiClient.create(connection);
    } on AppFailure catch (e) {
      throw ConnectionFailure(e.type);
    }
  }

  Future<void> update(Connection connection) async {
    try {
      await _apiClient.update(connection);
    } on AppFailure catch (e) {
      throw ConnectionFailure(e.type);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete(id);
    } on AppFailure catch (e) {
      throw ConnectionFailure(e.type);
    }
  }
}
