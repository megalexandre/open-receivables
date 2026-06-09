import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/members/domain/member_failure.dart';

void main() {
  group('MemberFailure.message', () {
    test('notFound retorna mensagem específica de sócio', () {
      expect(
        const MemberFailure(AppFailureType.notFound).message,
        'Sócio não encontrado.',
      );
    });

    test('network retorna mensagem do AppFailure base', () {
      expect(
        const MemberFailure(AppFailureType.network).message,
        'Falha de rede ao conectar no servidor.',
      );
    });

    test('server retorna mensagem do AppFailure base', () {
      expect(
        const MemberFailure(AppFailureType.server).message,
        'Falha no servidor.',
      );
    });

    test('invalidResponse retorna mensagem do AppFailure base', () {
      expect(
        const MemberFailure(AppFailureType.invalidResponse).message,
        'Resposta inválida da API.',
      );
    });
  });
}
