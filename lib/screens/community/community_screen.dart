import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/community_post_card.dart';
import '../../widgets/community_chat_card.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreatePostDialog();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Posts', icon: Icon(Icons.article)),
            Tab(text: 'Chat', icon: Icon(Icons.chat)),
            Tab(text: 'Experts', icon: Icon(Icons.people)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostsTab(),
          _buildChatTab(),
          _buildExpertsTab(),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    // Mock community posts data
    final posts = [
      {
        'id': '1',
        'author': 'Rajesh Kumar',
        'location': 'Punjab, India',
        'time': '2 hours ago',
        'content': 'Just harvested my wheat crop! The yield is 20% higher than last year. Used the new irrigation technique I learned from this community.',
        'likes': 24,
        'comments': 8,
        'image': null,
        'tags': ['Wheat', 'Harvest', 'Success'],
      },
      {
        'id': '2',
        'author': 'Priya Sharma',
        'location': 'Haryana, India',
        'time': '5 hours ago',
        'content': 'My tomato plants are showing signs of early blight. Any suggestions for organic treatment?',
        'likes': 12,
        'comments': 15,
        'image': null,
        'tags': ['Tomato', 'Disease', 'Help'],
      },
      {
        'id': '3',
        'author': 'Amit Singh',
        'location': 'Uttar Pradesh, India',
        'time': '1 day ago',
        'content': 'Sharing some photos from my organic farm. The soil health has improved significantly after using compost.',
        'likes': 36,
        'comments': 12,
        'image': 'farm_photo.jpg',
        'tags': ['Organic', 'Soil Health', 'Compost'],
      },
    ];

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh functionality
        await Future.delayed(const Duration(seconds: 1));
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
                    _buildStatItem('Active Farmers', '1,234', Icons.people),
                    _buildStatItem('Posts Today', '45', Icons.article),
                    _buildStatItem('Questions Solved', '89', Icons.help),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Posts
            ...posts.map((post) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CommunityPostCard(post: post),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    // Mock chat data
    final chats = [
      {
        'id': '1',
        'name': 'General Discussion',
        'lastMessage': 'Anyone tried the new organic fertilizer?',
        'time': '2 min ago',
        'unread': 3,
        'participants': 45,
      },
      {
        'id': '2',
        'name': 'Crop Health Help',
        'lastMessage': 'Thanks for the advice on pest control!',
        'time': '1 hour ago',
        'unread': 0,
        'participants': 23,
      },
      {
        'id': '3',
        'name': 'Market Prices',
        'lastMessage': 'Rice prices are up 15% this week',
        'time': '3 hours ago',
        'unread': 1,
        'participants': 67,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CommunityChatCard(chat: chat),
        );
      },
    );
  }

  Widget _buildExpertsTab() {
    // Mock experts data
    final experts = [
      {
        'id': '1',
        'name': 'Dr. Suresh Patel',
        'specialization': 'Crop Science',
        'experience': '15 years',
        'rating': 4.8,
        'reviews': 234,
        'isOnline': true,
      },
      {
        'id': '2',
        'name': 'Dr. Meera Sharma',
        'specialization': 'Soil Health',
        'experience': '12 years',
        'rating': 4.9,
        'reviews': 189,
        'isOnline': false,
      },
      {
        'id': '3',
        'name': 'Dr. Rajesh Kumar',
        'specialization': 'Pest Management',
        'experience': '18 years',
        'rating': 4.7,
        'reviews': 312,
        'isOnline': true,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: experts.length,
      itemBuilder: (context, index) {
        final expert = experts[index];
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
                Text(expert['name'].toString()),
                const SizedBox(width: 8),
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
                Text(expert['specialization'].toString()),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber[600],
                    ),
                    const SizedBox(width: 4),
                    Text('${expert['rating']} (${expert['reviews']} reviews)'),
                  ],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                _showExpertDetails(expert);
              },
              child: const Text('Consult'),
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

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Post'),
        content: const Text('Post creation functionality will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showExpertDetails(Map<String, dynamic> expert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expert['name'].toString()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specialization: ${expert['specialization'].toString()}'),
            Text('Experience: ${expert['experience'].toString()}'),
            Text('Rating: ${expert['rating'].toString()}/5'),
            Text('Reviews: ${expert['reviews'].toString()}'),
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
                  content: Text('Consultation feature coming soon'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Start Consultation'),
          ),
        ],
      ),
    );
  }
}

