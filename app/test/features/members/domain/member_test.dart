import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/members/domain/member.dart';

const _json = {
  'id': 42,
  'name': 'Ana Lima',
  'document': '12345678901',
  'member_number': 7,
  'voter': true,
};

const _member = Member(
  id: '42',
  name: 'Ana Lima',
  document: '12345678901',
  memberNumber: 7,
  voter: true,
);

void main() {
  group('Member.fromJson', () {
    test('mapeia todos os campos corretamente', () {
      final m = Member.fromJson(_json);
      expect(m.id, '42');
      expect(m.name, 'Ana Lima');
      expect(m.document, '12345678901');
      expect(m.memberNumber, 7);
      expect(m.voter, true);
    });

    test('id é convertido para String', () {
      final m = Member.fromJson(_json);
      expect(m.id, isA<String>());
    });

    test('memberNumber nulo quando ausente', () {
      final json = {..._json}..remove('member_number');
      final m = Member.fromJson(json);
      expect(m.memberNumber, isNull);
    });

    test('voter assume false quando ausente', () {
      final json = {..._json}..remove('voter');
      final m = Member.fromJson(json);
      expect(m.voter, false);
    });

    test('active assume true quando ausente', () {
      final m = Member.fromJson(_json);
      expect(m.active, true);
    });

    test('active false é mapeado', () {
      final m = Member.fromJson({..._json, 'active': false});
      expect(m.active, false);
    });

    test('memberNumber como num é convertido para int', () {
      final m = Member.fromJson({..._json, 'member_number': 3.0});
      expect(m.memberNumber, 3);
      expect(m.memberNumber, isA<int>());
    });
  });

  group('Member.toJson', () {
    test('produz as chaves snake_case corretas', () {
      final json = _member.toJson();
      expect(json['id'], '42');
      expect(json['name'], 'Ana Lima');
      expect(json['document'], '12345678901');
      expect(json['member_number'], 7);
      expect(json['voter'], true);
    });

    test('voter false é preservado', () {
      const m = Member(id: '1', name: 'X', document: '00000000000');
      expect(m.toJson()['voter'], false);
    });

    test('member_number nulo é preservado', () {
      const m = Member(id: '1', name: 'X', document: '00000000000');
      expect(m.toJson()['member_number'], isNull);
    });
  });

  group('Member.copyWith', () {
    test('campos não passados ficam inalterados', () {
      final m = _member.copyWith(name: 'Novo Nome');
      expect(m.name, 'Novo Nome');
      expect(m.id, _member.id);
      expect(m.document, _member.document);
      expect(m.memberNumber, _member.memberNumber);
      expect(m.voter, _member.voter);
    });

    test('todos os campos podem ser alterados', () {
      final m = _member.copyWith(
        id: 'novo-id',
        name: 'Outro',
        document: '98765432100',
        memberNumber: 99,
        voter: false,
        active: false,
      );
      expect(m.id, 'novo-id');
      expect(m.name, 'Outro');
      expect(m.document, '98765432100');
      expect(m.memberNumber, 99);
      expect(m.voter, false);
      expect(m.active, false);
    });
  });
}
