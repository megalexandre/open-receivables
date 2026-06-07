import 'package:organizagrana/features/members/data/members_api_client.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/features/members/domain/member_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

class MembersResult {
  const MembersResult({
    required this.members,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<Member> members;
  final int total;
  final int page;
  final int pageSize;
}

class MembersService {
  MembersService({required MembersApiClient apiClient})
      : _apiClient = apiClient;

  final MembersApiClient _apiClient;

  Future<MembersResult> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      return MembersResult(
        members: data.map(Member.fromJson).toList(),
        total: (json['total'] as num).toInt(),
        page: (json['page'] as num).toInt(),
        pageSize: (json['pageSize'] as num).toInt(),
      );
    } on AppFailure catch (e) {
      throw MemberFailure(e.type);
    }
  }

  Future<Member> create(Member member) async {
    try {
      final json = await _apiClient.create(member);
      return Member.fromJson(json);
    } on AppFailure catch (e) {
      throw MemberFailure(e.type);
    }
  }

  Future<Member> update(Member member) async {
    try {
      final json = await _apiClient.update(member);
      return Member.fromJson(json);
    } on AppFailure catch (e) {
      throw MemberFailure(e.type);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete(id);
    } on AppFailure catch (e) {
      throw MemberFailure(e.type);
    }
  }
}
