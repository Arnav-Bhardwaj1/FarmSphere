import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityItem({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final type = activity['type'] ?? 'Unknown';
    final crop = activity['crop'] ?? 'Unknown';
    final notes = activity['notes'] ?? '';
    final date = DateTime.parse(activity['date']);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Activity Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getActivityColor(type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getActivityIcon(type),
                color: _getActivityColor(type),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Activity Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    crop,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (notes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      notes,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatTime(date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'planting':
        return Icons.eco;
      case 'fertilizing':
        return Icons.agriculture;
      case 'irrigation':
        return Icons.water_drop;
      case 'pest control':
        return Icons.bug_report;
      case 'harvesting':
        return Icons.grass;
      case 'pruning':
        return Icons.content_cut;
      case 'weeding':
        return Icons.cleaning_services;
      case 'soil testing':
        return Icons.science;
      default:
        return Icons.assignment;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'planting':
        return Colors.green;
      case 'fertilizing':
        return Colors.brown;
      case 'irrigation':
        return Colors.blue;
      case 'pest control':
        return Colors.red;
      case 'harvesting':
        return Colors.orange;
      case 'pruning':
        return Colors.purple;
      case 'weeding':
        return Colors.teal;
      case 'soil testing':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    
    if (hour < 12) {
      return '${hour == 0 ? 12 : hour}:$minute AM';
    } else {
      return '${hour == 12 ? 12 : hour - 12}:$minute PM';
    }
  }
}

