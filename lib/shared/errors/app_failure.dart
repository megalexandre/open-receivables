enum AppFailureType { network, server, invalidResponse, notFound }

class AppFailure implements Exception {
  const AppFailure(this.type);

  final AppFailureType type;

  String get message => switch (type) {
        AppFailureType.network => 'Falha de rede ao conectar no servidor.',
        AppFailureType.server => 'Falha no servidor.',
        AppFailureType.invalidResponse => 'Resposta inválida da API.',
        AppFailureType.notFound => 'Recurso não encontrado.',
      };

  @override
  String toString() => message;
}
