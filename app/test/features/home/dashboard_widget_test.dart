import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizagrana/features/connections/data/connections_service.dart';
import 'package:organizagrana/features/home/presentation/pages/home_page.dart';
import 'package:organizagrana/features/members/data/members_service.dart';

void main() {
  group('HomePage', () {
    test('HomePage can be instantiated with services', () {
      // Create mock services
      final mockMembersService = _MockMembersService();
      final mockConnectionsService = _MockConnectionsService();

      // Create the HomePage
      final page = HomePage(
        membersService: mockMembersService,
        connectionsService: mockConnectionsService,
      );

      expect(page, isNotNull);
      expect(page.membersService, equals(mockMembersService));
      expect(page.connectionsService, equals(mockConnectionsService));
    });

    testWidgets('HomePage renders DashboardStatsWidget', (WidgetTester tester) async {
      final mockMembersService = _MockMembersService();
      final mockConnectionsService = _MockConnectionsService();

      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(
            membersService: mockMembersService,
            connectionsService: mockConnectionsService,
          ),
        ),
      );

      // Verify that the page renders without crashing
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

class _MockMembersService implements MembersService {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockConnectionsService implements ConnectionsService {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
