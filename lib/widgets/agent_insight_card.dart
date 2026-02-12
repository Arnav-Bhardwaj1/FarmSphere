import 'package:flutter/material.dart';
import '../models/agent_models.dart';

/// Widget to display agent insights on the home screen
class AgentInsightCard extends StatelessWidget {
  final AgentInsight insight;
  final VoidCallback onDismiss;
  final VoidCallback onAction;

  const AgentInsightCard({
    super.key,
    required this.insight,
    required this.onDismiss,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: _getGradientColors(insight.agentType),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    _getAgentIcon(insight.agentType),
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getAgentName(insight.agentType),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          insight.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: onDismiss,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                insight.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _getButtonColor(insight.agentType),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        insight.actionText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),

              // Priority Indicator
              if (insight.priority == AgentPriority.high ||
                  insight.priority == AgentPriority.critical) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      insight.priority == AgentPriority.critical
                          ? Icons.error
                          : Icons.warning,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      insight.priority == AgentPriority.critical
                          ? 'Critical'
                          : 'High Priority',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(AgentType type) {
    switch (type) {
      case AgentType.weather:
        return [Colors.orange.shade400, Colors.deepOrange.shade600];
      case AgentType.cropHealth:
        return [Colors.green.shade400, Colors.teal.shade600];
      case AgentType.activity:
        return [Colors.blue.shade400, Colors.indigo.shade600];
      case AgentType.market:
        return [Colors.purple.shade400, Colors.deepPurple.shade600];
      case AgentType.resource:
        return [Colors.teal.shade400, Colors.cyan.shade600];
    }
  }

  Color _getButtonColor(AgentType type) {
    switch (type) {
      case AgentType.weather:
        return Colors.deepOrange;
      case AgentType.cropHealth:
        return Colors.teal;
      case AgentType.activity:
        return Colors.indigo;
      case AgentType.market:
        return Colors.deepPurple;
      case AgentType.resource:
        return Colors.cyan;
    }
  }

  IconData _getAgentIcon(AgentType type) {
    switch (type) {
      case AgentType.weather:
        return Icons.wb_sunny;
      case AgentType.cropHealth:
        return Icons.local_florist;
      case AgentType.activity:
        return Icons.event;
      case AgentType.market:
        return Icons.trending_up;
      case AgentType.resource:
        return Icons.water_drop;
    }
  }

  String _getAgentName(AgentType type) {
    switch (type) {
      case AgentType.weather:
        return 'Weather Intelligence';
      case AgentType.cropHealth:
        return 'Crop Health Monitor';
      case AgentType.activity:
        return 'Activity Scheduler';
      case AgentType.market:
        return 'Market Intelligence';
      case AgentType.resource:
        return 'Resource Optimizer';
    }
  }
}

/// Compact version for the home screen
class CompactAgentInsightCard extends StatelessWidget {
  final AgentInsight insight;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const CompactAgentInsightCard({
    super.key,
    required this.insight,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getIconColor(insight.agentType).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getAgentIcon(insight.agentType),
                  color: _getIconColor(insight.agentType),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      insight.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconColor(AgentType type) {
    switch (type) {
      case AgentType.weather:
        return Colors.orange;
      case AgentType.cropHealth:
        return Colors.green;
      case AgentType.activity:
        return Colors.blue;
      case AgentType.market:
        return Colors.purple;
      case AgentType.resource:
        return Colors.teal;
    }
  }

  IconData _getAgentIcon(AgentType type) {
    switch (type) {
      case AgentType.weather:
        return Icons.wb_sunny;
      case AgentType.cropHealth:
        return Icons.local_florist;
      case AgentType.activity:
        return Icons.event;
      case AgentType.market:
        return Icons.trending_up;
      case AgentType.resource:
        return Icons.water_drop;
    }
  }
}
