import 'package:flutter/material.dart';

class SchemeCard extends StatelessWidget {
  final Map<String, dynamic> scheme;

  const SchemeCard({
    super.key,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final title = scheme['title'] ?? 'Unknown Scheme';
    final description = scheme['description'] ?? '';
    final eligibility = scheme['eligibility'] ?? '';
    final status = scheme['status'] ?? 'Unknown';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _getStatusColor(status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          status,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            if (eligibility.isNotEmpty) ...[
              const SizedBox(height: 12),
              
              // Eligibility
              Row(
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
                      'Eligibility: $eligibility',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showSchemeDetails(context, scheme);
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Learn More'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showSchemeDetails(BuildContext context, Map<String, dynamic> scheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(scheme['title'] ?? 'Scheme Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (scheme['description'] != null) ...[
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(scheme['description']),
                const SizedBox(height: 12),
              ],
              if (scheme['eligibility'] != null) ...[
                Text(
                  'Eligibility',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(scheme['eligibility']),
                const SizedBox(height: 12),
              ],
              if (scheme['status'] != null) ...[
                Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(scheme['status']),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement apply functionality
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Apply functionality coming soon'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

