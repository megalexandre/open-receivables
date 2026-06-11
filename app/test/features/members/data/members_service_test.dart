import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/members/data/members_api_client.dart';
import 'package:organizagrana/features/members/data/members_service.dart';
import 'package:organizagrana/features/members/domain/member.dart';
import 'package:organizagrana/features/members/domain/member_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

// Respostas no formato atual da API (MemberSerializer + Paginatable).
const _memberJson = {
  'id': 42,
  'name': 'Ana Lima',
  'document': '12345678901',
  'member_number': 7,
  'voter': true,
  'active': true,
};

const _listJson = {
  'data': [_memberJson],
  'pagination': {
    'total_count': 1,
    'current_page': 1,
    'per_page': 20,
  },
};

class _FakeMembersApiClient implements MembersApiClient {
  _FakeMembersApiClient({this.response, this.error});

  final Map<String, dynamic>? response;
  final Exception? error;

  bool? lastActive;

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 20,
    String? sortBy,
    bool sortAscending = true,
    String? name,
    String? document,
    bool? active,
  }) async {
    lastActive = active;
    if (error != null) throw error!;
    return response!;
  }

  @override
  Future<Map<String, dynamic>> create(Member member) async {
    if (error != null) throw error!;
    return response!;
  }

  @override
  Future<Map<String, dynamic>> update(Member member) async {
    if (error != null) throw error!;
    return response!;
  }

  @override
  Future<void> delete(String id) async {
    if (error != null) throw error!;
  }

  @override
  Future<Map<String, dynamic>> reactivate(String id) async {
    if (error != null) throw error!;
    return response!;
  }
}

void main() {
  group('MembersService.list', () {
    test('converte data e pagination do payload da API', () async {
      final service = MembersService(
        apiClient: _FakeMembersApiClient(response: _listJson),
      );

      final result = await service.list();

      expect(result.members, hasLength(1));
      expect(result.members.first.id, '42');
      expect(result.members.first.name, 'Ana Lima');
      expect(result.members.first.active, true);
      expect(result.total, 1);
      expect(result.page, 1);
      expect(result.pageSize, 20);
    });

    test('repassa o filtro active ao api client', () async {
      final apiClient = _FakeMembersApiClient(response: _listJson);
      final service = MembersService(apiClient: apiClient);

      await service.list(active: false);

      expect(apiClient.lastActive, false);
    });

    test('converte AppFailure em MemberFailure', () async {
      final service = MembersService(
        apiClient: _FakeMembersApiClient(
          error: const AppFailure(AppFailureType.notFound),
        ),
      );

      expect(
        () => service.list(),
        throwsA(isA<MemberFailure>()
            .having((f) => f.message, 'message', 'Sócio não encontrado.')),
      );
    });
  });

  group('MembersService.reactivate', () {
    test('retorna o Member da resposta da API', () async {
      final service = MembersService(
        apiClient: _FakeMembersApiClient(response: _memberJson),
      );

      final member = await service.reactivate('42');

      expect(member.id, '42');
      expect(member.active, true);
    });

    test('converte AppFailure em MemberFailure', () async {
      final service = MembersService(
        apiClient: _FakeMembersApiClient(
          error: const AppFailure(AppFailureType.server),
        ),
      );

      expect(
        () => service.reactivate('42'),
        throwsA(isA<MemberFailure>()),
      );
    });
  });
}
