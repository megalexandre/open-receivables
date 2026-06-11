import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/addresses/domain/address_failure.dart';

void main() {
  group('AddressFailure.message', () {
    test('notFound retorna mensagem específica de endereço', () {
      expect(
        const AddressFailure(AppFailureType.notFound).message,
        'Endereço não encontrado.',
      );
    });

    test('network retorna mensagem do AppFailure base', () {
      expect(
        const AddressFailure(AppFailureType.network).message,
        'Falha de rede ao conectar no servidor.',
      );
    });

    test('server retorna mensagem do AppFailure base', () {
      expect(
        const AddressFailure(AppFailureType.server).message,
        'Falha no servidor.',
      );
    });

    test('validation retorna mensagem do AppFailure base', () {
      expect(
        const AddressFailure(AppFailureType.validation).message,
        'Dados inválidos.',
      );
    });
  });
}
