import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/app/app_dependencies.dart';
import 'package:organizagrana/app/app_router.dart';
import 'package:organizagrana/app/app_theme.dart';
import 'package:organizagrana/app/auth_session_controller.dart';
import 'package:organizagrana/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  late final AuthSessionController _session;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    final deps = AppDependencies.create();
    _session = deps.session;
    _appRouter = deps.router;
    _session.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
    );
  }
}

// Inicia o app sem autenticação (sem tokens no storage)
Future<void> pumpUnauthenticated(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(const TestApp());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

// Inicia o app já autenticado (tokens pré-populados no storage)
Future<void> pumpAuthenticated(
  WidgetTester tester,
  String accessToken, {
  String refreshToken = 'fake-refresh',
}) async {
  SharedPreferences.setMockInitialValues({
    'access_token': accessToken,
    'refresh_token': refreshToken,
  });
  await tester.pumpWidget(const TestApp());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}
