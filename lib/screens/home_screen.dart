import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import '../providers/app_providers.dart';
import '../widgets/feature_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/weather_card.dart';
import '../widgets/alert_card.dart';
import '../widgets/activity_item.dart';
import '../widgets/agent_insight_card.dart';
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
    final agentState = ref.watch(agentProvider);
    final agentNotifier = ref.read(agentProvider.notifier);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.welcomeBack,
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
          Stack(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
                label: const Text(
                  'AI Agents',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/agents');
                },
              ),
              if (agentState.unacknowledgedDecisions.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${agentState.unacknowledgedDecisions.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
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
              
              // AI Agent Insights Section
              if (agentState.activeInsights.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI Recommendations',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/agents'),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...agentState.activeInsights.take(2).map((insight) {
                      return CompactAgentInsightCard(
                        insight: insight,
                        onTap: () => Navigator.pushNamed(context, '/agents'),
                        onDismiss: () => agentNotifier.dismissInsight(insight.id),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                ),
              
              // Alerts Section
              if (weatherState.alerts != null && weatherState.alerts!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.importantAlerts,
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
                t.quickActions,
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
                      label: t.scanCrop,
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
                      label: t.voiceHelp,
                      color: Colors.blue,
                      onTap: () {
                        // TODO: Implement voice help
                        _showComingSoonDialog(t.voiceHelp);
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
                      label: t.logActivity,
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
                      label: t.aiAssistant,
                      color: const Color(0xFF36946F),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AIChatbot(
                              title: t.chatbotTitle,
                              backgroundColor: const Color(0xFFF8F9FA),
                              appBarColor: const Color(0xFF36946F),
                              inputContainerColor: const Color(0xFF2D3648),
                              sendButtonColor: const Color(0xFF36946F),
                              hintText: t.chatbotHint,
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
                      label: t.community,
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
                      label: t.help,
                      color: Colors.grey,
                      onTap: () {
                        // TODO: Implement help screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.helpComingSoon),
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
                t.features,
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
                childAspectRatio: 4.4,
                children: [
                  FeatureCard(
                    icon: Icons.camera_alt,
                    title: t.aiCropHealth,
                    subtitle: t.scanDiagnoseDiseases,
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
                    title: t.weatherAlerts,
                    subtitle: t.getWeatherUpdates,
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
                    title: t.marketPrices,
                    subtitle: t.checkPricesSchemes,
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
                    title: t.analytics,
                    subtitle: t.trackActivities,
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
                t.recentActivities,
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
                              t.noActivitiesYet,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t.startLoggingActivities,
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ActivityItem(activity: activity),
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

  String _formatDate(String dateString, BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return t.today;
    } else if (difference == 1) {
      return t.yesterday;
    } else if (difference < 7) {
      return t.daysAgo(difference);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showComingSoonDialog(String feature) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature ${t.comingSoon}'),
        content: Text(t.featureUnderDevelopment),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.ok),
          ),
        ],
      ),
    );
  }
}

