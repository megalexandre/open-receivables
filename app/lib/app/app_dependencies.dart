import 'package:http/http.dart' as http;
import 'package:organizagrana/app/app_router.dart';
import 'package:organizagrana/app/auth_session_controller.dart';
import 'package:organizagrana/features/auth/data/auth_access_token_provider.dart';
import 'package:organizagrana/features/auth/data/auth_api_client.dart';
import 'package:organizagrana/features/auth/data/auth_service.dart';
import 'package:organizagrana/features/auth/data/auth_storage.dart';
import 'package:organizagrana/features/categories/data/categories_api_client.dart';
import 'package:organizagrana/features/categories/data/categories_service.dart';
import 'package:organizagrana/features/addresses/data/addresses_api_client.dart';
import 'package:organizagrana/features/addresses/data/addresses_service.dart';
import 'package:organizagrana/features/boletos/data/boletos_api_client.dart';
import 'package:organizagrana/features/boletos/data/boletos_service.dart';
import 'package:organizagrana/features/connections/data/connections_api_client.dart';
import 'package:organizagrana/features/connections/data/connections_service.dart';
import 'package:organizagrana/features/caixa/data/caixa_api_client.dart';
import 'package:organizagrana/features/caixa/data/caixa_service.dart';
import 'package:organizagrana/features/generate_invoices/data/generate_invoices_api_client.dart';
import 'package:organizagrana/features/generate_invoices/data/generate_invoices_service.dart';
import 'package:organizagrana/features/water_quality/data/water_quality_api_client.dart';
import 'package:organizagrana/features/water_quality/data/water_quality_service.dart';
import 'package:organizagrana/features/members/data/members_api_client.dart';
import 'package:organizagrana/features/members/data/members_service.dart';
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

    final featureHttpApiClient = HttpApiClient(
      httpClient: httpClient,
      bearerTokenProvider: tokenProvider.readAccessToken,
      tokenRefresher: authService.refreshAccessToken,
    );

    final categoriesService = CategoriesService(
      apiClient: HttpCategoriesApiClient(httpClient: featureHttpApiClient),
    );

    final membersService = MembersService(
      apiClient: HttpMembersApiClient(httpClient: featureHttpApiClient),
    );

    final addressesService = AddressesService(
      apiClient: HttpAddressesApiClient(httpClient: featureHttpApiClient),
    );

    final boletosService = BoletosService(
      apiClient: HttpBoletosApiClient(httpClient: featureHttpApiClient),
    );

    final connectionsService = ConnectionsService(
      apiClient: HttpConnectionsApiClient(httpClient: featureHttpApiClient),
    );

    final waterQualityService = WaterQualityService(
      apiClient: HttpWaterQualityApiClient(httpClient: featureHttpApiClient),
    );

    final caixaService = CaixaService(
      apiClient: HttpCaixaApiClient(httpClient: featureHttpApiClient),
    );

    final generateInvoicesService = GenerateInvoicesService(
      apiClient: HttpGenerateInvoicesApiClient(httpClient: featureHttpApiClient),
    );

    final router = AppRouter(
      session,
      categoriesService: categoriesService,
      membersService: membersService,
      addressesService: addressesService,
      boletosService: boletosService,
      connectionsService: connectionsService,
      waterQualityService: waterQualityService,
      caixaService: caixaService,
      generateInvoicesService: generateInvoicesService,
    );

    return AppDependencies._(session: session, router: router);
  }
}
