import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/features/members/domain/member_failure.dart';
import 'package:organizagrana/shared/network/api_endpoints.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

abstract class MembersApiClient {
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  });
  Future<Map<String, dynamic>> create(Member member);
  Future<Map<String, dynamic>> update(Member member);
  Future<void> delete(String id);
}

class MemberApiClientException implements Exception {
  const MemberApiClientException(this.type);

  final AppFailureType type;

  @override
  String toString() => MemberFailure(type).message;
}

class HttpMembersApiClient implements MembersApiClient {
  HttpMembersApiClient({required HttpApiClient httpClient})
      : _httpClient = httpClient;

  final HttpApiClient _httpClient;

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  }) {
    final params = <String, String>{
      'page': '$page',
      'pageSize': '$pageSize',
      if (sortBy != null) 'sortBy': sortBy,
      if (sortBy != null) 'sortOrder': sortAscending ? 'asc' : 'desc',
    };
    final uri = Uri.parse(ApiEndpoints.members.list)
        .replace(queryParameters: params);
    return _call(() => _httpClient.getJson(uri));
  }

  @override
  Future<Map<String, dynamic>> create(Member member) => _call(
        () => _httpClient.postJson(
          Uri.parse(ApiEndpoints.members.create),
          member.toJson()..remove('id'),
        ),
      );

  @override
  Future<Map<String, dynamic>> update(Member member) => _call(
        () => _httpClient.putJson(
          Uri.parse(ApiEndpoints.members.byId(member.id)),
          member.toJson(),
        ),
      );

  @override
  Future<void> delete(String id) => _callVoid(
        () => _httpClient.deleteVoid(Uri.parse(ApiEndpoints.members.byId(id))),
      );

  Future<Map<String, dynamic>> _call(
    Future<Map<String, dynamic>> Function() fn,
  ) async {
    try {
      return await fn();
    } on ApiException catch (e) {
      throw MemberApiClientException(_mapFailure(e.type));
    }
  }

  Future<void> _callVoid(Future<void> Function() fn) async {
    try {
      return await fn();
    } on ApiException catch (e) {
      throw MemberApiClientException(_mapFailure(e.type));
    }
  }

  AppFailureType _mapFailure(ApiFailureType type) => switch (type) {
        ApiFailureType.network => AppFailureType.network,
        ApiFailureType.unauthorized => AppFailureType.server,
        ApiFailureType.server => AppFailureType.server,
        ApiFailureType.invalidResponse => AppFailureType.invalidResponse,
      };
}
