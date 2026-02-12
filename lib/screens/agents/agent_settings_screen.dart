import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/agent_provider.dart';
import '../../models/agent_models.dart';
import '../../l10n/app_localizations.dart';

class AgentSettingsScreen extends ConsumerWidget {
  const AgentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentState = ref.watch(agentProvider);
    final agentNotifier = ref.read(agentProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.settings ?? 'Agent Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // General Settings
          _buildSectionTitle(context, 'General Settings'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  subtitle: const Text('Manage agent notifications'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to notification settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notification_important),
                  title: const Text('Test Notification'),
                  subtitle: const Text('Send a test notification'),
                  trailing: ElevatedButton(
                    onPressed: () => agentNotifier.sendTestNotification(),
                    child: const Text('Send Test'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Agent Controls
          _buildSectionTitle(context, 'Agent Controls'),
          Card(
            child: Column(
              children: AgentType.values.map((type) {
                final enabled = agentState.agentStatuses[type] ?? true;
                final info = _getAgentInfo(type);

                return SwitchListTile(
                  secondary: Icon(info['icon'] as IconData, color: info['color'] as Color),
                  title: Text(info['name'] as String),
                  subtitle: Text(info['description'] as String),
                  value: enabled,
                  onChanged: (value) => agentNotifier.toggleAgent(type, value),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Advanced Settings
          _buildSectionTitle(context, 'Advanced'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.play_circle),
                  title: const Text('Run Agents Now'),
                  subtitle: const Text('Manually trigger all agents'),
                  trailing: ElevatedButton.icon(
                    onPressed: () async {
                      await agentNotifier.runAgentsNow();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Agents executed successfully')),
                        );
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Run'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: const Text('Check Notifications'),
                  subtitle: const Text('Check for pending notifications'),
                  trailing: ElevatedButton.icon(
                    onPressed: () async {
                      await agentNotifier.checkNotifications();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Notifications checked')),
                        );
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Check'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh Data'),
                  subtitle: const Text('Reload all agent data'),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => agentNotifier.refresh(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Statistics
          _buildSectionTitle(context, 'Statistics'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow('Active Insights',
                      agentState.statistics['active_insights']?.toString() ?? '0'),
                  _buildStatRow('Recent Decisions',
                      agentState.statistics['recent_decisions']?.toString() ?? '0'),
                  _buildStatRow('Pending Tasks',
                      agentState.statistics['pending_tasks']?.toString() ?? '0'),
                  _buildStatRow('Notifications Sent',
                      agentState.statistics['notifications_sent']?.toString() ?? '0'),
                  _buildStatRow('Unacknowledged',
                      agentState.statistics['unacknowledged_decisions']?.toString() ?? '0'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // About
          _buildSectionTitle(context, 'About'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FarmSphere AI Agents',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Autonomous AI agents that monitor your farm, analyze data, and provide proactive recommendations to optimize your farming operations.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Features:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  _buildFeatureItem('Weather intelligence and alerts'),
                  _buildFeatureItem('Crop health monitoring'),
                  _buildFeatureItem('Activity scheduling'),
                  _buildFeatureItem('Market price analysis'),
                  _buildFeatureItem('Resource optimization'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Map<String, dynamic> _getAgentInfo(AgentType type) {
    switch (type) {
      case AgentType.weather:
        return {
          'name': 'Weather Intelligence',
          'description': 'Real-time weather analysis and alerts',
          'icon': Icons.wb_sunny,
          'color': Colors.orange,
        };
      case AgentType.cropHealth:
        return {
          'name': 'Crop Health Monitor',
          'description': 'Pattern detection and disease prevention',
          'icon': Icons.local_florist,
          'color': Colors.green,
        };
      case AgentType.activity:
        return {
          'name': 'Activity Scheduler',
          'description': 'Personalized farming schedules',
          'icon': Icons.event,
          'color': Colors.blue,
        };
      case AgentType.market:
        return {
          'name': 'Market Intelligence',
          'description': 'Price trends and selling opportunities',
          'icon': Icons.trending_up,
          'color': Colors.purple,
        };
      case AgentType.resource:
        return {
          'name': 'Resource Optimizer',
          'description': 'Water and fertilizer optimization',
          'icon': Icons.water_drop,
          'color': Colors.teal,
        };
    }
  }
}
