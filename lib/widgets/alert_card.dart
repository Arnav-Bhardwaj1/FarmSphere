import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AlertCard({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    final severity = alert['severity']?.toString().toLowerCase() ?? 'low';
    final color = _getSeverityColor(severity);
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getAlertIcon(alert['type']),
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        alert['type'] ?? 'Alert',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          severity.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert['message'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (alert['time'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(alert['time']),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getAlertIcon(String? type) {
    if (type == null) return Icons.warning;
    
    switch (type.toLowerCase()) {
      case 'rain alert':
        return Icons.grain;
      case 'pest alert':
        return Icons.bug_report;
      case 'weather alert':
        return Icons.wb_cloudy;
      case 'disease alert':
        return Icons.health_and_safety;
      default:
        return Icons.warning;
    }
  }

  String _formatTime(String timeString) {
    try {
      final time = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = time.difference(now);
      
      if (difference.inHours > 0) {
        return 'In ${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return 'In ${difference.inMinutes}m';
      } else {
        return 'Now';
      }
    } catch (e) {
      return 'Soon';
    }
  }
}

