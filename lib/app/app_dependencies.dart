import 'package:http/http.dart' as http;
import 'package:organizagrana/app/app_router.dart';
import 'package:organizagrana/app/auth_session_controller.dart';
import 'package:organizagrana/features/auth/data/auth_access_token_provider.dart';
import 'package:organizagrana/features/auth/data/auth_api_client.dart';
import 'package:organizagrana/features/auth/data/auth_service.dart';
import 'package:organizagrana/features/auth/data/auth_storage.dart';
import 'package:organizagrana/shared/network/http_api_client.dart';

/// Composition root da aplicação: monta a sessão e o roteador.
/// Usado tanto pelo app real ([MainApp]) quanto pelos testes de integração
/// — que injetam um [http.Client] mockado via [httpClient].
class AppDependencies {
  AppDependencies._({required this.session, required this.router});

  final AuthSessionController session;
  final AppRouter router;

  factory AppDependencies.create({http.Client? httpClient}) {
    httpClient ??= http.Client();

    final authStorage = AuthStorage();
    final tokenProvider = AuthStorageAccessTokenProvider(authStorage);

    final authApiClient = HttpAuthApiClient(
      tokenProvider,
      httpClient: HttpApiClient(httpClient: httpClient),
    );

    final authService = AuthService(authStorage, apiClient: authApiClient);
    final session = AuthSessionController(authService: authService);

    // ignore: unused_local_variable — disponível para as features injetarem
    final featureHttpApiClient = HttpApiClient(
      httpClient: httpClient,
      bearerTokenProvider: tokenProvider.readAccessToken,
      tokenRefresher: authService.refreshAccessToken,
    );

    final router = AppRouter(session);

    return AppDependencies._(session: session, router: router);
  }
}
