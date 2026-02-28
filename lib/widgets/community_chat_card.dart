import 'package:flutter/material.dart';
import 'package:farmsphere/l10n/app_localizations.dart';

class CommunityChatCard extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback? onTap;

  const CommunityChatCard({
    super.key,
    required this.chat,
    this.onTap,
  });

  // Gradient colors for avatars based on chat name
  List<Color> _getAvatarGradient(String name) {
    final gradients = [
      [const Color(0xFF43A047), const Color(0xFF2E7D32)],
      [const Color(0xFF1976D2), const Color(0xFF0D47A1)],
      [const Color(0xFFE65100), const Color(0xFFBF360C)],
      [const Color(0xFF7B1FA2), const Color(0xFF4A148C)],
      [const Color(0xFF00838F), const Color(0xFF006064)],
      [const Color(0xFFC62828), const Color(0xFF8E0000)],
    ];
    return gradients[name.hashCode.abs() % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final unreadCount = chat['unread'] as int;
    final chatName = chat['name'].toString();
    final avatarColors = _getAvatarGradient(chatName);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Profile avatar with gradient
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: avatarColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: avatarColors[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      chatName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: unreadCount > 0 ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            chat['time'],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: unreadCount > 0 ? avatarColors[0] : Colors.grey[500],
                              fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['lastMessage'],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: unreadCount > 0 
                                    ? Theme.of(context).textTheme.bodyLarge?.color 
                                    : Colors.grey[500],
                                fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: avatarColors),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: avatarColors[0].withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.people_outline_rounded, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            '${chat['participants']} ${t.members}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
