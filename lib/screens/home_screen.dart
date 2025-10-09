import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/feature_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/weather_card.dart';
import '../widgets/alert_card.dart';
import '../chatbot.dart';
import 'crop_health/crop_health_screen.dart';
import 'weather/weather_screen.dart';
import 'market/market_screen.dart';
import 'activities/activities_screen.dart';
import 'community/community_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final userState = ref.read(userProvider);
    if (userState.location != null) {
      ref.read(weatherProvider.notifier).fetchWeatherData(userState.location!);
    }
    ref.read(marketPricesProvider.notifier).fetchMarketData();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final weatherState = ref.watch(weatherProvider);
    final marketState = ref.watch(marketPricesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Text(
              userState.name ?? 'Farmer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weather Card
              if (weatherState.currentWeather != null)
                WeatherCard(weather: weatherState.currentWeather!),
              
              const SizedBox(height: 16),
              
              // Alerts Section
              if (weatherState.alerts != null && weatherState.alerts!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important Alerts',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...weatherState.alerts!.map((alert) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AlertCard(alert: alert),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.camera_alt,
                      label: 'Scan Crop',
                      color: Colors.green,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CropHealthScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.record_voice_over,
                      label: 'Voice Help',
                      color: Colors.blue,
                      onTap: () {
                        // TODO: Implement voice help
                        _showComingSoonDialog('Voice Help');
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.add_circle_outline,
                      label: 'Log Activity',
                      color: Colors.orange,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ActivitiesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.chat,
                      label: 'AI Assistant',
                      color: const Color(0xFF36946F),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AIChatbot(
                              title: 'FarmSphere AI Assistant',
                              backgroundColor: Color(0xFFF8F9FA),
                              appBarColor: Color(0xFF36946F),
                              inputContainerColor: Color(0xFF2D3648),
                              sendButtonColor: Color(0xFF36946F),
                              hintText: 'Ask me about farming...',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.people,
                      label: 'Community',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CommunityScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickActionButton(
                      icon: Icons.help_outline,
                      label: 'Help',
                      color: Colors.grey,
                      onTap: () {
                        // TODO: Implement help screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Help feature coming soon!'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Main Features
              Text(
                'Features',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Feature Cards Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  FeatureCard(
                    icon: Icons.camera_alt,
                    title: 'AI Crop Health',
                    subtitle: 'Scan and diagnose crop diseases',
                    color: Colors.green,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CropHealthScreen(),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.wb_sunny,
                    title: 'Weather & Alerts',
                    subtitle: 'Get weather updates and alerts',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const WeatherScreen(),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.trending_up,
                    title: 'Market Prices',
                    subtitle: 'Check crop prices and schemes',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MarketScreen(),
                        ),
                      );
                    },
                  ),
                  FeatureCard(
                    icon: Icons.analytics,
                    title: 'Analytics',
                    subtitle: 'Track your farm activities',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ActivitiesScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Recent Activities
              Text(
                'Recent Activities',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Consumer(
                builder: (context, ref, child) {
                  final activityState = ref.watch(activityProvider);
                  
                  if (activityState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (activityState.activities == null || activityState.activities!.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No activities yet',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Start logging your farm activities',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return Column(
                    children: activityState.activities!.take(3).map((activity) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            child: Icon(
                              _getActivityIcon(activity['type']),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: Text(activity['type']),
                          subtitle: Text(activity['crop']),
                          trailing: Text(
                            _formatDate(activity['date']),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
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
      case 'harvesting':
        return Icons.grass;
      default:
        return Icons.assignment;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature Coming Soon'),
        content: Text('This feature is under development and will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

