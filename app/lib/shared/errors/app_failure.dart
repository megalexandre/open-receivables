import 'package:organizagrana/shared/network/http_api_client.dart';

export 'package:organizagrana/shared/network/http_api_client.dart'
    show ApiValidationError;

enum AppFailureType { network, server, invalidResponse, notFound, validation }

class AppFailure implements Exception {
  const AppFailure(this.type);

  final AppFailureType type;

  String get message => switch (type) {
        AppFailureType.network => 'Falha de rede ao conectar no servidor.',
        AppFailureType.server => 'Falha no servidor.',
        AppFailureType.invalidResponse => 'Resposta inválida da API.',
        AppFailureType.notFound => 'Recurso não encontrado.',
        AppFailureType.validation => 'Dados inválidos.',
      };

  @override
  String toString() => message;
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(this.errors) : super(AppFailureType.validation);

  final List<ApiValidationError> errors;
}
