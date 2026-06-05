import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/categories/domain/category_failure.dart';

void main() {
  group('CategoryFailure.message', () {
    test('notFound retorna mensagem específica de categoria', () {
      expect(
        const CategoryFailure(AppFailureType.notFound).message,
        'Categoria não encontrada.',
      );
    });

    test('network retorna mensagem do AppFailure base', () {
      expect(
        const CategoryFailure(AppFailureType.network).message,
        'Falha de rede ao conectar no servidor.',
      );
    });

    test('server retorna mensagem do AppFailure base', () {
      expect(
        const CategoryFailure(AppFailureType.server).message,
        'Falha no servidor.',
      );
    });

    test('invalidResponse retorna mensagem do AppFailure base', () {
      expect(
        const CategoryFailure(AppFailureType.invalidResponse).message,
        'Resposta inválida da API.',
      );
    });
  });
}
