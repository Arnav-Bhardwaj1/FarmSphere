import 'package:flutter/material.dart';

class CommunityPostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const CommunityPostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
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
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    post['author'].toString().split(' ').map((n) => n[0]).join(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['author'],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${post['location']} • ${post['time']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    _showPostOptions(context);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Content
            Text(
              post['content'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            // Tags
            if (post['tags'] != null && (post['tags'] as List).isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: (post['tags'] as List).map<Widget>((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Actions
            Row(
              children: [
                _buildActionButton(
                  context,
                  Icons.thumb_up_outlined,
                  '${post['likes']}',
                  () {
                    // TODO: Implement like functionality
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  context,
                  Icons.comment_outlined,
                  '${post['comments']}',
                  () {
                    // TODO: Implement comment functionality
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  context,
                  Icons.share_outlined,
                  'Share',
                  () {
                    // TODO: Implement share functionality
                  },
                ),
                const Spacer(),
                _buildActionButton(
                  context,
                  Icons.bookmark_outline,
                  'Save',
                  () {
                    // TODO: Implement save functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report Post'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement report functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block User'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement block functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement copy link functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}

