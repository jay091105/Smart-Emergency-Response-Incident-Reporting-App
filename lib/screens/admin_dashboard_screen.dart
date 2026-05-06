import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/incident.dart';

/// Sample incident data for demo/testing
final List<Incident> _sampleIncidents = [
  Incident(id: 'INC-1001', title: 'Multi-vehicle collision on I-95', description: 'Severe accident blocking all lanes', timestamp: DateTime.now().subtract(const Duration(minutes: 12))),
  Incident(id: 'INC-1002', title: 'Warehouse fire reported', description: 'Structure fire at industrial zone', timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 5))),
  Incident(id: 'INC-1003', title: 'Heart attack - CPR in progress', description: 'Medical emergency downtown', timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
  Incident(id: 'INC-1004', title: 'Minor flooding reported', description: 'Localized flooding in low-lying area', timestamp: DateTime.now().subtract(const Duration(hours: 6))),
  Incident(id: 'INC-1005', title: 'Power outage in sector 4', description: 'Grid failure affecting residential area', timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2))),
  Incident(id: 'INC-1006', title: 'Armed robbery in progress', description: 'Active robbery at convenience store', timestamp: DateTime.now().subtract(const Duration(minutes: 7))),
  Incident(id: 'INC-1007', title: 'Elevator stuck with occupants', description: 'People trapped, assistance needed', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
  Incident(id: 'INC-1008', title: 'Gas leak detected', description: 'Potential hazard - evacuation planned', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
];

/// Riverpod providers
final incidentsProvider = StateProvider<List<Incident>>((ref) => _sampleIncidents);

final totalIncidentsProvider = Provider<int>((ref) => ref.watch(incidentsProvider).length);

final activeIncidentsProvider = Provider<int>((ref) {
  // Simplified: incidents from last 24h are "active"
  final now = DateTime.now();
  final threshold = now.subtract(const Duration(days: 1));
  return ref.watch(incidentsProvider).where((i) => i.timestamp.isAfter(threshold)).length;
});

final resolvedIncidentsProvider = Provider<int>((ref) {
  // Simplified: incidents older than 7 days are "resolved"
  final now = DateTime.now();
  final threshold = now.subtract(const Duration(days: 7));
  return ref.watch(incidentsProvider).where((i) => i.timestamp.isBefore(threshold)).length;
});

final criticalIncidentsProvider = Provider<int>((ref) {
  // Simplified: incidents with "critical" in title
  return ref.watch(incidentsProvider).where((i) => i.title.toLowerCase().contains('critical') || i.title.toLowerCase().contains('armed') || i.title.toLowerCase().contains('fire')).length;
});

final topCriticalProvider = Provider<List<Incident>>((ref) {
  // Top critical incidents (last 3 hours, sorted by time)
  final now = DateTime.now();
  final threshold = now.subtract(const Duration(hours: 3));
  final critical = ref.watch(incidentsProvider).where((i) => i.timestamp.isAfter(threshold)).toList();
  critical.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return critical.take(3).toList();
});

/// Admin Dashboard Screen
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(totalIncidentsProvider);
    final active = ref.watch(activeIncidentsProvider);
    final resolved = ref.watch(resolvedIncidentsProvider);
    final critical = ref.watch(criticalIncidentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Text('AD', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top summary cards
              _SummaryCardsSection(total: total, active: active, resolved: resolved, critical: critical),
              const SizedBox(height: 24),

              // Responsive layout: charts and critical alerts
              LayoutBuilder(builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _ChartsSection(ref: ref)),
                          const SizedBox(width: 16),
                          Expanded(flex: 1, child: _CriticalAndActionsSection(ref: ref)),
                        ],
                      )
                    : Column(
                        children: [
                          _ChartsSection(ref: ref),
                          const SizedBox(height: 16),
                          _CriticalAndActionsSection(ref: ref),
                        ],
                      );
              }),
              const SizedBox(height: 24),

              // Recent incidents
              _RecentIncidentsSection(ref: ref),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to report incident screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Incident feature')),
          );
        },
        icon: const Icon(Icons.add_alert),
        label: const Text('Add Incident'),
      ),
    );
  }
}

/// Summary cards section (responsive grid)
class _SummaryCardsSection extends StatelessWidget {
  final int total, active, resolved, critical;
  const _SummaryCardsSection({required this.total, required this.active, required this.resolved, required this.critical});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 700;
      final cards = [
        _SummaryCard(icon: Icons.report_problem, label: 'Total Incidents', count: total, color: Colors.blue),
        _SummaryCard(icon: Icons.flash_on, label: 'Active Incidents', count: active, color: Colors.orange),
        _SummaryCard(icon: Icons.check_circle, label: 'Resolved Incidents', count: resolved, color: Colors.green),
        _SummaryCard(icon: Icons.warning_amber_rounded, label: 'Critical Incidents', count: critical, color: Colors.red),
      ];

      if (isWide) {
        return GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.2,
          children: cards,
        );
      } else {
        return Column(
          children: cards
              .map((c) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: SizedBox(height: 96, child: c),
                  ))
              .toList(),
        );
      }
    });
  }
}

/// Summary card widget
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  const _SummaryCard({required this.icon, required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [            Container(
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(count.toString(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(label, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Container(
              width: 6,
              height: 44,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Charts section (priority pie chart & status bar chart)
class _ChartsSection extends StatelessWidget {
  final WidgetRef ref;
  const _ChartsSection({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Priority distribution pie chart
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Priority Distribution', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 12),
                SizedBox(height: 220, child: _PriorityPieChart()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Status distribution bar chart
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status Distribution', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 12),
                SizedBox(height: 220, child: _StatusBarChart()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Priority pie chart
class _PriorityPieChart extends StatelessWidget {
  const _PriorityPieChart();

  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(color: Colors.red, value: 4, title: '40%', radius: 60, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      PieChartSectionData(color: Colors.orange, value: 3, title: '30%', radius: 60, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      PieChartSectionData(color: Colors.amber, value: 2, title: '20%', radius: 60, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
      PieChartSectionData(color: Colors.green, value: 1, title: '10%', radius: 60, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
    ];

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _LegendItem(label: 'Critical', color: Colors.red),
              SizedBox(height: 8),
              _LegendItem(label: 'High', color: Colors.orange),
              SizedBox(height: 8),
              _LegendItem(label: 'Medium', color: Colors.amber),
              SizedBox(height: 8),
              _LegendItem(label: 'Low', color: Colors.green),
            ],
          ),
        )
      ],
    );
  }
}

/// Legend item for pie chart
class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 12, height: 12, color: color, margin: const EdgeInsets.only(right: 8)),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }
}

/// Status bar chart
class _StatusBarChart extends StatelessWidget {
  const _StatusBarChart();

  @override
  Widget build(BuildContext context) {
    final groups = [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5, color: Colors.blue, width: 18)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3, color: Colors.orange, width: 18)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2, color: Colors.green, width: 18)]),
    ];

    return BarChart(
      BarChartData(
        maxY: 6,
        groupsSpace: 24,
        barGroups: groups,
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toInt()) {
                  case 0:
                    text = 'Reported';
                    break;
                  case 1:
                    text = 'In Progress';
                    break;
                  case 2:
                    text = 'Resolved';
                    break;
                  default:
                    text = '';
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(text, style: const TextStyle(fontSize: 12)),
                );
              },
              reservedSize: 80,
            ),
          ),
        ),
        gridData: FlGridData(show: false),
      ),
    );
  }
}

/// Critical alerts and quick actions section
class _CriticalAndActionsSection extends StatelessWidget {
  final WidgetRef ref;
  const _CriticalAndActionsSection({required this.ref});

  @override
  Widget build(BuildContext context) {
    final topCritical = ref.watch(topCriticalProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Critical alerts
        Card(
          color: Colors.red.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Critical Alerts', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.red)),
                const SizedBox(height: 8),
                if (topCritical.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('No critical incidents', style: TextStyle(fontSize: 14)),
                  )
        else
                  ...topCritical.map((i) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: _CriticalItem(incident: i))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Quick actions
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _ActionButton(label: 'Add Incident', icon: Icons.add, color: Colors.blue),
                    _ActionButton(label: 'View Reports', icon: Icons.bar_chart, color: Colors.purple),
                    _ActionButton(label: 'Search', icon: Icons.search, color: Colors.teal),
                    _ActionButton(label: 'Responders', icon: Icons.group, color: Colors.orange),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Critical item in alerts section
class _CriticalItem extends StatelessWidget {
  final Incident incident;
  const _CriticalItem({required this.incident});

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(incident.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(8)),
                    child: const Text('CRITICAL', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(_timeAgo(incident.timestamp), style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
        )
      ],
    );
  }
}

/// Action button widget
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _ActionButton({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

/// Recent incidents section
class _RecentIncidentsSection extends ConsumerWidget {
  final WidgetRef ref;
  const _RecentIncidentsSection({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final incidents = widgetRef.watch(incidentsProvider).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Incidents', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incidents.length,
              separatorBuilder: (_, __) => const Divider(height: 12),
              itemBuilder: (context, index) => _RecentIncidentTile(incident: incidents[index]),
            )
          ],
        ),
      ),
    );
  }
}

/// Recent incident tile
class _RecentIncidentTile extends StatelessWidget {
  final Incident incident;
  const _RecentIncidentTile({required this.incident});

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      leading: Container(
        width: 8,
        height: 56,
        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
      ),
      title: Text(incident.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(incident.description, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: const Text('Active', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(height: 8),
          Text(_timeAgo(incident.timestamp), style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
