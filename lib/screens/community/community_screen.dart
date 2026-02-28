import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import '../../widgets/community_post_card.dart';
import '../../widgets/community_chat_card.dart';
import '../../providers/app_providers.dart';
import '../payment_screen.dart';

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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: [
            Tab(text: t.posts, icon: const Icon(Icons.article_rounded)),
            Tab(text: t.chat, icon: const Icon(Icons.chat_rounded)),
            Tab(text: t.experts, icon: const Icon(Icons.verified_user_rounded)),
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

    return Column(
      children: [
        // Search bar
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: Colors.grey[500], size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          ),
        ),
      ],
    );
  }

  // Premium gradient colors for expert avatars
  static const List<List<Color>> _expertGradients = [
    [Color(0xFF43A047), Color(0xFF2E7D32)],
    [Color(0xFF1976D2), Color(0xFF0D47A1)],
    [Color(0xFFE65100), Color(0xFFBF360C)],
    [Color(0xFF7B1FA2), Color(0xFF4A148C)],
    [Color(0xFF00838F), Color(0xFF006064)],
  ];

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
        final isOnline = expert['isOnline'] as bool;
        final gradientColors = _expertGradients[index % _expertGradients.length];
        final fee = expert['fee'] ?? 499;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar with online indicator
                      Stack(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors[0].withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                expert['name'].toString().split(' ').map((n) => n[0]).join(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          if (isOnline)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Theme.of(context).cardColor, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4CAF50).withOpacity(0.5),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    expert['name'].toString(),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1976D2).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.verified_rounded, color: Color(0xFF1976D2), size: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: gradientColors[0].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                expert['specialization'].toString(),
                                style: TextStyle(
                                  color: gradientColors[0],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ...List.generate(5, (i) {
                                  final rating = (expert['rating'] as num).toDouble();
                                  return Icon(
                                    i < rating.floor() ? Icons.star_rounded
                                        : (i < rating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                                    size: 16,
                                    color: Colors.amber[600],
                                  );
                                }),
                                const SizedBox(width: 6),
                                Text(
                                  '${expert['rating']} (${expert['reviews']})',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          expert['experience']?.toString() ?? '5+ years exp.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          '₹$fee',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: gradientColors[0],
                          ),
                        ),
                        Text(
                          '/session',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _startConsultation(expert),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.video_call_rounded, color: Colors.white, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              t.consult,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

  // Gradient colors for chat user avatars
  Color _getUserAvatarColor(String name) {
    final colors = [
      const Color(0xFF43A047),
      const Color(0xFF1976D2),
      const Color(0xFFE65100),
      const Color(0xFF7B1FA2),
      const Color(0xFF00838F),
      const Color(0xFFC62828),
      const Color(0xFF283593),
      const Color(0xFF00695C),
    ];
    return colors[name.hashCode.abs() % colors.length];
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  // Premium gradient app bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              (chat['name'] ?? 'C').toString().split(' ').map((n) => n.isNotEmpty ? n[0] : '').join(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chat['name'] ?? 'Chat',
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${chat['participants'] ?? 0} members',
                                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white70),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ],
                    ),
                  ),
                  // Messages
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.chat_bubble_outline_rounded, size: 56, color: Colors.grey[400]),
                                  const SizedBox(height: 12),
                                  Text(
                                    t.noMessagesYet,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Be the first to say hello!',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final isMe = message['userId'] == userId;
                                final msgUserName = message['userName'] ?? 'User';
                                final avatarColor = _getUserAvatarColor(msgUserName);
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (!isMe) ...[
                                        Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [avatarColor, avatarColor.withOpacity(0.7)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: avatarColor.withOpacity(0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              msgUserName[0].toUpperCase(),
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            gradient: isMe
                                                ? const LinearGradient(
                                                    colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  )
                                                : null,
                                            color: isMe ? null : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                                            borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(18),
                                              topRight: const Radius.circular(18),
                                              bottomLeft: Radius.circular(isMe ? 18 : 4),
                                              bottomRight: Radius.circular(isMe ? 4 : 18),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (!isMe)
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 4),
                                                  child: Text(
                                                    msgUserName,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: avatarColor,
                                                    ),
                                                  ),
                                                ),
                                              Text(
                                                message['content'] ?? '',
                                                style: TextStyle(
                                                  color: isMe ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                                                  fontSize: 14,
                                                  height: 1.3,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    message['time'] ?? '',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: isMe ? Colors.white60 : Colors.grey[500],
                                                    ),
                                                  ),
                                                  if (isMe) ...[
                                                    const SizedBox(width: 4),
                                                    Icon(Icons.done_all_rounded, size: 14, color: Colors.white.withOpacity(0.7)),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isMe) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  // Premium input area
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: messageController,
                              decoration: InputDecoration(
                                hintText: t.messageHint,
                                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2E7D32).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
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
    final issueController = TextEditingController();
    final fee = (expert['fee'] ?? 499).toDouble();
    
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Expert avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    expertName.split(' ').map((n) => n[0]).join(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                expertName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                expert['specialization'].toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, size: 18, color: Colors.amber[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${expert['rating']}/5 · ${expert['reviews']} ${t.reviews.toLowerCase()}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: issueController,
                decoration: InputDecoration(
                  hintText: 'Describe your farming issue or question...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(t.close),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogCtx).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                expertName: expertName,
                                specialization: expert['specialization'].toString(),
                                consultationFee: fee,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.payment_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Pay ₹${fee.toStringAsFixed(0)} & ${t.startConsultation}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
