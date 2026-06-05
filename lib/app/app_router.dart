import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:organizagrana/app/auth_session_controller.dart';
import 'package:organizagrana/features/auth/presentation/pages/login_page.dart';
import 'package:organizagrana/features/categories/data/categories_service.dart';
import 'package:organizagrana/features/categories/presentation/pages/categories_page.dart';
import 'package:organizagrana/features/members/data/members_service.dart';
import 'package:organizagrana/features/members/presentation/pages/members_page.dart';
import 'package:organizagrana/features/home/presentation/pages/home_page.dart';
import 'package:organizagrana/shared/layout/layout_page.dart';
import 'package:organizagrana/shared/layout/side_menu/layout_menu_config.dart';
import 'package:organizagrana/shared/layout/side_menu/layout_menu_item.dart';

final RouteObserver<ModalRoute<void>> appRouteObserver = RouteObserver<ModalRoute<void>>();

class AppRouter {
  AppRouter(this._session, {required this.categoriesService, required this.membersService});

  final AuthSessionController _session;
  final CategoriesService categoriesService;
  final MembersService membersService;

  // Instância, não estático: um GlobalKey de navigator estático sobrevive a hot
  // reloads e é o gatilho clássico de "Duplicate GlobalKey" no go_router.
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static const String rootPath = '/';
  static const String loginPath = '/login';
  static const String homePath = '/home';
  static const String categoriesPath = '/categories';
  static const String membersPath = '/members';

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: rootPath,
    refreshListenable: _session,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isLogin = location == loginPath;
      final isRoot = location == rootPath;

      if (!_session.initialized) {
        return isRoot ? null : rootPath;
      }

      if (!_session.isAuthenticated) {
        return isLogin ? null : loginPath;
      }

      if (isRoot || isLogin) {
        return homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: rootPath,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: _LoadingPage(),
        ),
      ),
      GoRoute(
        path: loginPath,
        pageBuilder: (context, state) => NoTransitionPage(
          child: LoginPage(onLogin: _session.login),
        ),
      ),
      ShellRoute(
        observers: [appRouteObserver],
        builder: (context, state, child) {
          return _AppShell(
            onLogout: _session.logout,
            profile: _session.displayProfile,
            currentPath: state.uri.path,
            body: child,
          );
        },
        routes: [
          GoRoute(
            path: homePath,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: categoriesPath,
            pageBuilder: (context, state) => NoTransitionPage(
              child: CategoriesPage(service: categoriesService),
            ),
          ),
          GoRoute(
            path: membersPath,
            pageBuilder: (context, state) => NoTransitionPage(
              child: MembersPage(service: membersService),
            ),
          ),
        ],
      ),
    ],
  );
}

class _AppShell extends StatefulWidget {
  const _AppShell({
    required this.onLogout,
    required this.currentPath,
    required this.body,
    this.profile,
  });

  final Future<void> Function() onLogout;
  final String currentPath;
  final Widget body;
  final dynamic profile;

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  List<LayoutMenuItem> _menuItems = [];

  @override
  void initState() {
    super.initState();
    LayoutMenuConfig.load().then((items) {
      if (mounted) setState(() => _menuItems = items);
    });
  }

  int get _selectedIndex {
    for (var i = 0; i < _menuItems.length; i++) {
      if (widget.currentPath.startsWith('/${_menuItems[i].id}')) return i;
    }
    return 0;
  }

  void _onMenuSelect(int index) {
    if (index < _menuItems.length) {
      context.go('/${_menuItems[index].id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      title: 'App',
      menuItems: _menuItems,
      selectedIndex: _selectedIndex,
      onMenuSelect: _onMenuSelect,
      onLogout: widget.onLogout,
      profile: widget.profile,
      body: widget.body,
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
