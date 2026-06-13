import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/addresses/data/addresses_api_client.dart';
import 'package:organizagrana/features/addresses/data/addresses_service.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/addresses/domain/address_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

// Respostas no formato atual da API (AddressSerializer + Paginatable).
const _addressJson = {
  'id': 42,
  'address_type': 'Rua',
  'name': 'das Flores',
  'notes': null,
};

const _listJson = {
  'data': [_addressJson],
  'pagination': {
    'total_count': 1,
    'current_page': 1,
    'per_page': 20,
  },
};

class _FakeAddressesApiClient implements AddressesApiClient {
  _FakeAddressesApiClient({this.response, this.error});

  final Map<String, dynamic>? response;
  final Exception? error;

  @override
  Future<Map<String, dynamic>> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
    String? addressType,
    String? name,
    bool? active,
  }) async {
    if (error != null) throw error!;
    return response!;
  }

  @override
  Future<Map<String, dynamic>> create(Address address) async {
    if (error != null) throw error!;
    return response!;
  }

  @override
  Future<Map<String, dynamic>> update(Address address) async {
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
  group('AddressesService.list', () {
    test('converte data e pagination do payload da API', () async {
      final service = AddressesService(
        apiClient: _FakeAddressesApiClient(response: _listJson),
      );

      final result = await service.list();

      expect(result.addresses, hasLength(1));
      expect(result.addresses.first.id, '42');
      expect(result.addresses.first.addressType, 'Rua');
      expect(result.addresses.first.name, 'das Flores');
      expect(result.total, 1);
      expect(result.page, 1);
      expect(result.pageSize, 20);
    });

    test('converte AppFailure em AddressFailure', () async {
      final service = AddressesService(
        apiClient: _FakeAddressesApiClient(
          error: const AppFailure(AppFailureType.notFound),
        ),
      );

      expect(
        () => service.list(),
        throwsA(isA<AddressFailure>()
            .having((f) => f.message, 'message', 'Endereço não encontrado.')),
      );
    });
  });

  group('AddressesService.create', () {
    test('retorna o Address da resposta da API', () async {
      final service = AddressesService(
        apiClient: _FakeAddressesApiClient(response: _addressJson),
      );

      final created = await service.create(
        const Address(id: '', addressType: 'Rua', name: 'das Flores'),
      );

      expect(created.id, '42');
      expect(created.name, 'das Flores');
    });

    test('repassa ValidationFailure sem converter', () async {
      final service = AddressesService(
        apiClient: _FakeAddressesApiClient(
          error: const ValidationFailure([]),
        ),
      );

      expect(
        () => service.create(
          const Address(id: '', addressType: 'Rua', name: 'das Flores'),
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });
}
