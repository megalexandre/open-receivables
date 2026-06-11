import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/shared/errors/api_error_code.dart';

void main() {
  group('ApiErrorCode.fromCode', () {
    test('mapeia os códigos semânticos da API', () {
      expect(ApiErrorCode.fromCode('E_ADDRESS_DUPLICATED'),
          ApiErrorCode.addressDuplicated);
      expect(ApiErrorCode.fromCode('E_CATEGORY_DUPLICATED'),
          ApiErrorCode.categoryNameDuplicated);
      expect(ApiErrorCode.fromCode('E_CATEGORY_REQUIRED'),
          ApiErrorCode.categoryMemberTypeRequired);
      expect(ApiErrorCode.fromCode('E_CATEGORY_INVALID'),
          ApiErrorCode.categoryMemberTypeInvalid);
      expect(ApiErrorCode.fromCode('E_MEMBER_DUPLICATED'),
          ApiErrorCode.memberDocumentDuplicated);
    });

    test('código desconhecido cai em unknown', () {
      expect(ApiErrorCode.fromCode('E_3_1'), ApiErrorCode.unknown);
      expect(ApiErrorCode.fromCode(''), ApiErrorCode.unknown);
    });
  });

  group('mensagens', () {
    test('addressDuplicated interpola tipo e nome do endereço', () {
      const address = Address(id: '1', addressType: 'Rua', name: 'das Flores');
      final params = ApiErrorCode.paramsFromAddress(address);

      expect(
        ApiErrorCode.addressDuplicated.messageFor(params),
        'O logradouro "Rua das Flores" já está cadastrado',
      );
    });

    test('unknown retorna mensagem genérica', () {
      expect(ApiErrorCode.unknown.messageFor({}), 'Erro desconhecido');
    });
  });
}
