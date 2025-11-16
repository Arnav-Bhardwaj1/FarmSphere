import 'package:flutter/material.dart';
import 'package:farmsphere/l10n/app_localizations.dart';

class CommunityPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final bool isLiked;
  final bool isSaved;
  final List<Map<String, dynamic>> comments;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onReport;
  final VoidCallback? onBlock;
  final VoidCallback? onCopyLink;

  const CommunityPostCard({
    super.key,
    required this.post,
    this.isLiked = false,
    this.isSaved = false,
    this.comments = const [],
    this.onLike,
    this.onSave,
    this.onComment,
    this.onShare,
    this.onReport,
    this.onBlock,
    this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                  isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  '${post['likes']}',
                  onLike ?? () {},
                  color: isLiked ? Theme.of(context).colorScheme.primary : Colors.grey[600]!,
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  context,
                  Icons.comment_outlined,
                  '${post['comments']}',
                  onComment ?? () {},
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  context,
                  Icons.share_outlined,
                  t.share,
                  onShare ?? () {},
                ),
                const Spacer(),
                _buildActionButton(
                  context,
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  t.saveAction,
                  onSave ?? () {},
                  color: isSaved ? Theme.of(context).colorScheme.primary : Colors.grey[600]!,
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
    VoidCallback onTap, {
    Color? color,
  }) {
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
              color: color ?? Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color ?? Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report),
              title: Text(t.reportPost),
              onTap: () {
                Navigator.of(context).pop();
                onReport?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(t.blockUser),
              onTap: () {
                Navigator.of(context).pop();
                onBlock?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(t.copyLink),
              onTap: () {
                Navigator.of(context).pop();
                onCopyLink?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
