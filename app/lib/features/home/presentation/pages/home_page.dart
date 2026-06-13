import 'package:flutter/material.dart';
import 'package:organizagrana/features/connections/data/connections_service.dart';
import 'package:organizagrana/features/home/presentation/widgets/dashboard_stats_widget.dart';
import 'package:organizagrana/features/members/data/members_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.membersService,
    required this.connectionsService,
  });

  final MembersService membersService;
  final ConnectionsService connectionsService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashboardStatsWidget(
        membersService: membersService,
        connectionsService: connectionsService,
      ),
    );
  }
}
