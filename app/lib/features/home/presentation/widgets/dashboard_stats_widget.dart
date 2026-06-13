import 'package:flutter/material.dart';
import 'package:organizagrana/features/connections/data/connections_service.dart';
import 'package:organizagrana/features/members/data/members_service.dart';

class DashboardStatsWidget extends StatefulWidget {
  const DashboardStatsWidget({
    super.key,
    required this.membersService,
    required this.connectionsService,
  });

  final MembersService membersService;
  final ConnectionsService connectionsService;

  @override
  State<DashboardStatsWidget> createState() => _DashboardStatsWidgetState();
}

class _DashboardStatsWidgetState extends State<DashboardStatsWidget> {
  late Future<(int, int)> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStats();
  }

  Future<(int, int)> _loadStats() async {
    final membersResult = await widget.membersService.list(
      pageSize: 1,
      active: true,
    );
    final connectionsResult = await widget.connectionsService.list(
      pageSize: 1,
      active: true,
    );
    return (membersResult.total, connectionsResult.total);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar estatísticas: ${snapshot.error}'),
          );
        }

        final (activeMembers, activeConnections) = snapshot.data ?? (0, 0);

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard do Sistema',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Members Ativos',
                      value: activeMembers.toString(),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _StatCard(
                      title: 'Conexões Ativas',
                      value: activeConnections.toString(),
                      icon: Icons.link,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
