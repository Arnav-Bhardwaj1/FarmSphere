import 'package:flutter/material.dart';

class DiagnosisResultCard extends StatelessWidget {
  final Map<String, dynamic> diagnosis;
  final bool isCompact;
  final bool showTimestamp;

  const DiagnosisResultCard({
    super.key,
    required this.diagnosis,
    this.isCompact = false,
    this.showTimestamp = false,
  });

  @override
  Widget build(BuildContext context) {
    final disease = diagnosis['disease'] ?? 'Unknown';
    final confidence = diagnosis['confidence'] ?? 0.0;
    final severity = diagnosis['severity'] ?? 'Unknown';
    final recommendations = diagnosis['recommendations'] as List<dynamic>? ?? [];
    final prevention = diagnosis['prevention'] as List<dynamic>? ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(severity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _getSeverityColor(severity).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    disease,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: _getSeverityColor(severity),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${(confidence * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            if (showTimestamp && diagnosis['timestamp'] != null) ...[
              const SizedBox(height: 8),
              Text(
                _formatTimestamp(diagnosis['timestamp']),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
            
            if (!isCompact) ...[
              const SizedBox(height: 12),
              
              // Severity
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    size: 16,
                    color: _getSeverityColor(severity),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Severity: $severity',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getSeverityColor(severity),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Recommendations
              if (recommendations.isNotEmpty) ...[
                Text(
                  'Treatment Recommendations',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rec.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
              ],
              
              // Prevention
              if (prevention.isNotEmpty) ...[
                Text(
                  'Prevention Tips',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...prevention.map((prev) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 16,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prev.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }
}

