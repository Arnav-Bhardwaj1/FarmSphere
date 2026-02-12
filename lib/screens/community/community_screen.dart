import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import '../../widgets/community_post_card.dart';
import '../../widgets/community_chat_card.dart';
import '../../providers/app_providers.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final communityState = ref.watch(communityProvider);
    final userState = ref.watch(userProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t.farmerCommunity),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreatePostDialog(userState.location ?? 'Unknown Location');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: t.posts, icon: const Icon(Icons.article)),
            Tab(text: t.chat, icon: const Icon(Icons.chat)),
            Tab(text: t.experts, icon: const Icon(Icons.people)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostsTab(communityState, userState),
          _buildChatTab(communityState, userState),
          _buildExpertsTab(communityState, userState),
        ],
      ),
    );
  }

  Widget _buildPostsTab(CommunityState state, UserState userState) {
    final t = AppLocalizations.of(context)!;
    final userId = userState.userId ?? 'guest_user';
    final filteredPosts = state.posts.where((post) => 
      !state.blockedUsers.contains(post['authorId'])
    ).toList();

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(communityProvider.notifier).refreshPosts();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Quick Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(t.activeFarmers, '1,234', Icons.people),
                    _buildStatItem(t.postsToday, '${filteredPosts.length}', Icons.article),
                    _buildStatItem(t.questionsSolved, '89', Icons.help),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Posts
            if (filteredPosts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No posts yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to share something!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredPosts.map((post) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                  child: CommunityPostCard(
                    post: post,
                    isLiked: state.likedPosts[post['id']]?.contains(userId) ?? false,
                    isSaved: state.savedPosts[post['id']]?.contains(userId) ?? false,
                    comments: state.postComments[post['id']] ?? [],
                    onLike: () async => await ref.read(communityProvider.notifier).toggleLike(post['id'], userId),
                    onSave: () async => await ref.read(communityProvider.notifier).toggleSave(post['id'], userId),
                    onComment: () => _showCommentDialog(post['id'], userId, userState.name ?? 'User'),
                    onShare: () => _sharePost(post),
                    onReport: () => _reportPost(post['id']),
                    onBlock: () => _blockUser(post['authorId'], post['author']),
                    onCopyLink: () => _copyLink(post['id']),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab(CommunityState state, UserState userState) {
    final t = AppLocalizations.of(context)!;
    final userId = userState.userId ?? 'guest_user';
    final userName = userState.name ?? 'User';

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.chats.length,
      itemBuilder: (context, index) {
        final chat = state.chats[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CommunityChatCard(
            chat: chat,
            onTap: () => _openChat(context, chat, userId, userName, state),
          ),
        );
      },
    );
  }

  Widget _buildExpertsTab(CommunityState state, UserState userState) {
    final t = AppLocalizations.of(context)!;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.experts.length,
      itemBuilder: (context, index) {
        final expert = state.experts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Text(
                expert['name'].toString().split(' ').map((n) => n[0]).join(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(child: Text(expert['name'].toString())),
                if (expert['isOnline'] as bool)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${t.specialization}: ${expert['specialization'].toString()}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber[600],
                    ),
                    const SizedBox(width: 4),
                    Text('${expert['rating']} (${expert['reviews']} ${t.reviews.toLowerCase()})'),
                  ],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                _startConsultation(expert);
              },
              child: Text(t.consult),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showCreatePostDialog(String defaultLocation) {
    final t = AppLocalizations.of(context)!;
    final userState = ref.read(userProvider);
    final contentController = TextEditingController();
    final tagsController = TextEditingController();
    final locationController = TextEditingController(text: defaultLocation);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.createPost),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: t.postContent,
                  hintText: t.postContentHint,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 5,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: t.location,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: t.tags,
                  hintText: t.tagsHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.tag),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final content = contentController.text.trim();
              if (content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.pleaseEnterContent)),
                );
                return;
              }
              
              final location = locationController.text.trim().isEmpty 
                  ? defaultLocation 
                  : locationController.text.trim();
              
              final tags = tagsController.text
                  .split(',')
                  .map((t) => t.trim())
                  .where((t) => t.isNotEmpty)
                  .toList();
              
              final userId = userState.userId ?? 'guest_user';
              final userName = userState.name ?? 'User';
              
              ref.read(communityProvider.notifier).createPost(
                content,
                location,
                tags,
                userId,
                userName,
              );
              
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.postCreatedSuccess),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(t.save),
          ),
        ],
      ),
    );
  }

  void _showCommentDialog(String postId, String userId, String userName) {
    final t = AppLocalizations.of(context)!;
    final commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final communityState = ref.watch(communityProvider);
          final comments = communityState.postComments[postId] ?? [];
          
          return Dialog(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text('${t.comments} (${comments.length})'),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  Flexible(
                    child: comments.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.comment_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    t.noCommentsYet,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                          child: Text(
                                            (comment['userName'] ?? 'User')[0].toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment['userName'] ?? 'User',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                comment['time'] ?? '',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40, top: 4),
                                      child: Text(
                                        comment['content'] ?? '',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ),
                                    if (index < comments.length - 1)
                                      const Divider(height: 24),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: t.commentHint,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (text) async {
                              if (text.trim().isNotEmpty) {
                                await ref.read(communityProvider.notifier).addComment(
                                  postId,
                                  userId,
                                  userName,
                                  text.trim(),
                                );
                                commentController.clear();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            final text = commentController.text.trim();
                            if (text.isNotEmpty) {
                              await ref.read(communityProvider.notifier).addComment(
                                postId,
                                userId,
                                userName,
                                text,
                              );
                              commentController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _sharePost(Map<String, dynamic> post) {
    // In a real app, this would use platform-specific sharing
    final postLink = 'https://farmsphere.com/post/${post['id']}';
    Clipboard.setData(ClipboardData(text: postLink));
    
    final t = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${t.share}: $postLink'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _reportPost(String postId) {
    final t = AppLocalizations.of(context)!;
    ref.read(communityProvider.notifier).reportPost(postId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.postReported),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _blockUser(String userId, String userName) {
    final t = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.blockUser),
        content: Text('Are you sure you want to block $userName? You will no longer see their posts.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(communityProvider.notifier).blockUser(userId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.userBlocked),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(t.blockUser),
          ),
        ],
      ),
    );
  }

  void _copyLink(String postId) {
    final t = AppLocalizations.of(context)!;
    final postLink = 'https://farmsphere.com/post/$postId';
    Clipboard.setData(ClipboardData(text: postLink));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.linkCopied),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _openChat(BuildContext context, Map<String, dynamic> chat, String userId, String userName, CommunityState initialState) {
    final t = AppLocalizations.of(context)!;
    final chatId = chat['id'];
    final messageController = TextEditingController();
    
    // Load messages from API when opening chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(communityProvider.notifier).loadChatMessages(chatId);
    });
    
    showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(communityProvider);
          final messages = state.chatMessages[chatId] ?? [];
          
          return Dialog(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  AppBar(
                    title: Text(chat['name'] ?? 'Chat'),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: messages.isEmpty
                        ? Center(
                            child: Text(
                              t.noMessagesYet,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMe = message['userId'] == userId;
                              
                              return Align(
                                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isMe 
                                        ? Colors.green[700]
                                        : Colors.grey[800],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (!isMe)
                                        Text(
                                          message['userName'] ?? 'User',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      Text(
                                        message['content'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: t.messageHint,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onSubmitted: (text) async {
                              if (text.trim().isNotEmpty) {
                                await ref.read(communityProvider.notifier).addChatMessage(
                                  chatId,
                                  userId,
                                  userName,
                                  text.trim(),
                                );
                                messageController.clear();
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            final text = messageController.text.trim();
                            if (text.isNotEmpty) {
                              await ref.read(communityProvider.notifier).addChatMessage(
                                chatId,
                                userId,
                                userName,
                                text,
                              );
                              messageController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _startConsultation(Map<String, dynamic> expert) {
    final t = AppLocalizations.of(context)!;
    final expertName = expert['name'].toString();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expertName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${t.specialization}: ${expert['specialization'].toString()}'),
            Text('${t.experience}: ${expert['experience'].toString()}'),
            Text('${t.rating}: ${expert['rating'].toString()}/5'),
            Text('${t.reviews}: ${expert['reviews'].toString()}'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Describe your farming issue or question...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.close),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              final consultationMessage = t.consultationStarted(expertName);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(consultationMessage),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(t.startConsultation),
          ),
        ],
      ),
    );
  }
}
