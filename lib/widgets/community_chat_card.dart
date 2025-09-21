import 'package:flutter/material.dart';

class CommunityChatCard extends StatelessWidget {
  final Map<String, dynamic> chat;

  const CommunityChatCard({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount = chat['unread'] as int;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Text(
            chat['name'].toString().split(' ').map((n) => n[0]).join(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chat['name'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unreadCount',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat['lastMessage'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${chat['participants']} members',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                const Spacer(),
                Text(
                  chat['time'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          _showChatDetails(context, chat);
        },
      ),
    );
  }

  void _showChatDetails(BuildContext context, Map<String, dynamic> chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(chat['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Members: ${chat['participants']}'),
            Text('Last message: ${chat['time']}'),
            const SizedBox(height: 16),
            const Text('Chat functionality will be available soon.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat feature coming soon'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Join Chat'),
          ),
        ],
      ),
    );
  }
}

