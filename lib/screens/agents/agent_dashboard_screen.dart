import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/agent_provider.dart';
import '../../models/agent_models.dart';
import '../../l10n/app_localizations.dart';

class AgentDashboardScreen extends ConsumerWidget {
  const AgentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentState = ref.watch(agentProvider);
    final agentNotifier = ref.read(agentProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.agentDashboard ?? 'AI Agents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => agentNotifier.refresh(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/agent-settings');
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: agentState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => agentNotifier.refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Web platform warning
                  if (kIsWeb) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        border: Border.all(color: Colors.orange.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'AI Agents require mobile or desktop app. Web version has limited functionality.',
                              style: TextStyle(
                                color: Colors.orange.shade900,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Statistics Card
                  _buildStatisticsCard(context, agentState.statistics),
                  const SizedBox(height: 16),

                  // Agent Status Cards
                  _buildSectionTitle(context, 'Active Agents'),
                  const SizedBox(height: 8),
                  ...AgentType.values.map((type) => _buildAgentCard(
                        context,
                        ref,
                        type,
                        agentState.agentStatuses[type] ?? true,
                      )),

                  const SizedBox(height: 24),

                  // Unacknowledged Decisions
                  if (agentState.unacknowledgedDecisions.isNotEmpty) ...[
                    _buildSectionTitle(
                        context, 'Important Recommendations', Icons.priority_high),
                    const SizedBox(height: 8),
                    ...agentState.unacknowledgedDecisions
                        .map((decision) =>
                            _buildDecisionCard(context, ref, decision)),
                  ],

                  const SizedBox(height: 24),

                  // Active Insights
                  if (agentState.activeInsights.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Active Insights', Icons.lightbulb),
                    const SizedBox(height: 8),
                    ...agentState.activeInsights
                        .map((insight) => _buildInsightCard(context, ref, insight)),
                  ],

                  const SizedBox(height: 24),

                  // Recent Decisions
                  _buildSectionTitle(context, 'Recent Activity', Icons.history),
                  const SizedBox(height: 8),
                  ...agentState.recentDecisions
                      .take(5)
                      .map((decision) => _buildDecisionCard(context, ref, decision)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            await agentNotifier.runAgentsNow();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agents executed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e is UnsupportedError 
                      ? 'AI Agents are not available on web. Please use the mobile or desktop app.'
                      : 'Error running agents: $e'
                  ),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          }
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Run Now'),
      ),
    );
  }

  Widget _buildStatisticsCard(
      BuildContext context, Map<String, dynamic> statistics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agent Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Active Insights',
                  statistics['active_insights']?.toString() ?? '0',
                  Icons.lightbulb_outline,
                  Colors.amber,
                ),
                _buildStatItem(
                  'Pending Tasks',
                  statistics['pending_tasks']?.toString() ?? '0',
                  Icons.schedule,
                  Colors.blue,
                ),
              _buildStatItem(
                'Enabled Agents',
                statistics['agents_enabled']?.toString() ?? '0',
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title,
      [IconData? icon]) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildAgentCard(
      BuildContext context, WidgetRef ref, AgentType type, bool enabled) {
    final agentNotifier = ref.read(agentProvider.notifier);

    final agentInfo = _getAgentInfo(type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(agentInfo['icon'] as IconData, color: agentInfo['color'] as Color),
        title: Text(
          agentInfo['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          agentInfo['description'] as String,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[700],
          ),
        ),
        trailing: Switch(
          value: enabled,
          onChanged: (value) => agentNotifier.toggleAgent(type, value),
        ),
      ),
    );
  }

  Widget _buildDecisionCard(
      BuildContext context, WidgetRef ref, AgentDecision decision) {
    final agentNotifier = ref.read(agentProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getPriorityIcon(decision.priority),
                  color: _getPriorityColor(decision.priority),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    decision.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!decision.acknowledged)
                  const Icon(Icons.circle, color: Colors.red, size: 12),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              decision.message,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Confidence: ${(decision.confidence * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[700],
              ),
            ),
            if (decision.actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: decision.actions.take(3).map((action) {
                  return Chip(
                    label: Text(
                      action,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue[100]
                            : Colors.blue[900],
                      ),
                    ),
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blue[900]
                        : Colors.blue[50],
                  );
                }).toList(),
              ),
            ],
            if (!decision.acknowledged) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => agentNotifier.acknowledgeDecision(decision.id),
                child: const Text('Acknowledge'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(
      BuildContext context, WidgetRef ref, AgentInsight insight) {
    final agentNotifier = ref.read(agentProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => agentNotifier.dismissInsight(insight.id),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              insight.description,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Handle action based on insight data
              },
              child: Text(insight.actionText),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getAgentInfo(AgentType type) {
    switch (type) {
      case AgentType.weather:
        return {
          'name': 'Weather Intelligence',
          'description': 'Analyzes weather and provides alerts',
          'icon': Icons.wb_sunny,
          'color': Colors.orange,
        };
      case AgentType.cropHealth:
        return {
          'name': 'Crop Health Monitor',
          'description': 'Detects disease patterns',
          'icon': Icons.local_florist,
          'color': Colors.green,
        };
      case AgentType.activity:
        return {
          'name': 'Activity Scheduler',
          'description': 'Suggests farming activities',
          'icon': Icons.event,
          'color': Colors.blue,
        };
      case AgentType.market:
        return {
          'name': 'Market Intelligence',
          'description': 'Tracks prices and opportunities',
          'icon': Icons.trending_up,
          'color': Colors.purple,
        };
      case AgentType.resource:
        return {
          'name': 'Resource Optimizer',
          'description': 'Optimizes water and fertilizer usage',
          'icon': Icons.water_drop,
          'color': Colors.teal,
        };
    }
  }

  IconData _getPriorityIcon(AgentPriority priority) {
    switch (priority) {
      case AgentPriority.critical:
        return Icons.error;
      case AgentPriority.high:
        return Icons.warning;
      case AgentPriority.medium:
        return Icons.info;
      case AgentPriority.low:
        return Icons.info_outline;
    }
  }

  Color _getPriorityColor(AgentPriority priority) {
    switch (priority) {
      case AgentPriority.critical:
        return Colors.red;
      case AgentPriority.high:
        return Colors.orange;
      case AgentPriority.medium:
        return Colors.blue;
      case AgentPriority.low:
        return Colors.grey;
    }
  }
}
