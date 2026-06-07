import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/categories/domain/category.dart';

const _json = {
  'id': 'cat-1',
  'name': 'Residencial Padrão',
  'group_id': 1,
  'has_hydrometer': true,
  'amount_water': 50.0,
  'amount_partner': 3.0,
};

const _category = Category(
  id: 'cat-1',
  name: 'Residencial Padrão',
  groupId: 1,
  waterMeter: true,
  waterValue: 50.0,
  memberValue: 3.0,
);

void main() {
  group('Category.fromJson', () {
    test('mapeia todos os campos corretamente', () {
      final c = Category.fromJson(_json);
      expect(c.id, 'cat-1');
      expect(c.name, 'Residencial Padrão');
      expect(c.groupId, 1);
      expect(c.waterMeter, true);
      expect(c.waterValue, 50.0);
      expect(c.memberValue, 3.0);
    });

    test('water_meter false é preservado', () {
      final c = Category.fromJson({..._json, 'water_meter': false});
      expect(c.waterMeter, false);
    });
  });

  group('Category.toJson', () {
    test('produz as chaves snake_case corretas', () {
      final json = _category.toJson();
      expect(json['id'], 'cat-1');
      expect(json['water_meter'], true);
      expect(json['water_value'], 50.0);
      expect(json['member_value'], 3.0);
    });
  });

  group('Category.total', () {
    test('soma waterValue e memberValue', () {
      expect(_category.total, 53.0);
    });

    test('zero quando ambos são zero', () {
      const c = Category(
        id: '', name: '',
        waterMeter: false, waterValue: 0, memberValue: 0,
      );
      expect(c.total, 0.0);
    });
  });

  group('Category.copyWith', () {
    test('campos não passados ficam inalterados', () {
      final c = _category.copyWith(name: 'Novo Nome');
      expect(c.name, 'Novo Nome');
      expect(c.id, _category.id);
      expect(c.groupId, _category.groupId);
      expect(c.waterMeter, _category.waterMeter);
      expect(c.waterValue, _category.waterValue);
      expect(c.memberValue, _category.memberValue);
    });

    test('todos os campos podem ser alterados', () {
      final c = _category.copyWith(
        id: 'new-id',
        name: 'Outro',
        groupId: 2,
        waterMeter: false,
        waterValue: 10.0,
        memberValue: 2.0,
      );
      expect(c.id, 'new-id');
      expect(c.name, 'Outro');
      expect(c.groupId, 2);
      expect(c.waterMeter, false);
      expect(c.waterValue, 10.0);
      expect(c.memberValue, 2.0);
    });
  });
}
