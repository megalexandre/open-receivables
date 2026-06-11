import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';

// Payload no formato do AddressSerializer da API: id int e apenas campos de domínio.
const _json = {
  'id': 42,
  'address_type': 'Rua',
  'name': 'das Flores',
  'notes': 'Próximo à praça',
};

const _address = Address(
  id: '42',
  addressType: 'Rua',
  name: 'das Flores',
  notes: 'Próximo à praça',
);

void main() {
  group('Address.fromJson', () {
    test('mapeia todos os campos corretamente', () {
      final a = Address.fromJson(_json);
      expect(a.id, '42');
      expect(a.addressType, 'Rua');
      expect(a.name, 'das Flores');
      expect(a.notes, 'Próximo à praça');
    });

    test('id int é convertido para String', () {
      final a = Address.fromJson(_json);
      expect(a.id, isA<String>());
    });

    test('id String também é aceito', () {
      final a = Address.fromJson({..._json, 'id': '42'});
      expect(a.id, '42');
    });

    test('notes nulo quando ausente', () {
      final json = {..._json}..remove('notes');
      final a = Address.fromJson(json);
      expect(a.notes, isNull);
    });

    test('address_type vazio quando ausente', () {
      final json = {..._json}..remove('address_type');
      final a = Address.fromJson(json);
      expect(a.addressType, '');
    });
  });

  group('Address.toJson', () {
    test('produz as chaves snake_case corretas', () {
      final json = _address.toJson();
      expect(json['id'], '42');
      expect(json['address_type'], 'Rua');
      expect(json['name'], 'das Flores');
      expect(json['notes'], 'Próximo à praça');
    });

    test('omite notes quando nulo', () {
      const a = Address(id: '1', addressType: 'Rua', name: 'X');
      expect(a.toJson().containsKey('notes'), isFalse);
    });
  });

  group('Address.copyWith', () {
    test('campos não passados ficam inalterados', () {
      final a = _address.copyWith(name: 'Novo Nome');
      expect(a.name, 'Novo Nome');
      expect(a.id, _address.id);
      expect(a.addressType, _address.addressType);
      expect(a.notes, _address.notes);
    });

    test('todos os campos podem ser alterados', () {
      final a = _address.copyWith(
        id: 'novo-id',
        addressType: 'Avenida',
        name: 'Brasil',
        notes: 'Outra nota',
      );
      expect(a.id, 'novo-id');
      expect(a.addressType, 'Avenida');
      expect(a.name, 'Brasil');
      expect(a.notes, 'Outra nota');
    });
  });
}
