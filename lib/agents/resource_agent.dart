import 'package:flutter/foundation.dart';
import '../models/agent_models.dart';
import '../services/agent_service.dart';
import '../services/agent_database.dart';

/// Resource Optimization Agent - Optimizes water and fertilizer usage
class ResourceAgent {
  static const AgentType agentType = AgentType.resource;

  /// Analyze resource usage and generate optimization recommendations
  static Future<void> analyze({
    required List<Map<String, dynamic>> activityHistory,
    required Map<String, dynamic>? analytics,
    required String location,
    String? userId,
  }) async {
    if (kDebugMode) {
      print('ResourceAgent: Starting analysis');
    }

    try {
      // Check if agent is enabled
      final isEnabled = await AgentDatabase.isAgentEnabled(agentType);
      if (!isEnabled) {
        if (kDebugMode) {
          print('ResourceAgent: Agent is disabled');
        }
        return;
      }

      // Analyze water usage patterns
      await _analyzeWaterUsage(activityHistory);

      // Analyze fertilizer usage
      await _analyzeFertilizerUsage(activityHistory);

      // Generate cost optimization recommendations
      await _generateCostOptimizations(activityHistory, analytics);

      // Provide sustainability recommendations
      await _generateSustainabilityTips(activityHistory, location);

      if (kDebugMode) {
        print('ResourceAgent: Analysis completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ResourceAgent: Error during analysis - $e');
      }
    }
  }

  /// Analyze water usage patterns
  static Future<void> _analyzeWaterUsage(
    List<Map<String, dynamic>> activities,
  ) async {
    final irrigationActivities =
        activities.where((a) => a['type'] == 'Irrigation').toList();

    if (irrigationActivities.isEmpty) {
      await _createWaterUsageInsight(
        'Start Tracking Water Usage',
        'Begin logging irrigation activities to get personalized water optimization recommendations.',
        'start_tracking',
        AgentPriority.low,
      );
      return;
    }

    // Calculate irrigation frequency
    final last30Days =
        DateTime.now().subtract(const Duration(days: 30));
    final recentIrrigations = irrigationActivities.where((a) {
      final date = DateTime.parse(
          a['date'] ?? a['timestamp'] ?? DateTime.now().toIso8601String());
      return date.isAfter(last30Days);
    }).length;

    // Analyze patterns
    if (recentIrrigations > 45) {
      // More than 1.5 times per day on average
      await _createOverirrigationAlert(recentIrrigations);
    } else if (recentIrrigations < 10) {
      // Less than 3 times per week
      await _createUnderirrigationAlert(recentIrrigations);
    }

    // Check for optimal timing
    await _analyzeIrrigationTiming(irrigationActivities);

    // Water conservation tips
    if (recentIrrigations > 30) {
      await _createWaterConservationInsight();
    }
  }

  /// Analyze fertilizer usage patterns
  static Future<void> _analyzeFertilizerUsage(
    List<Map<String, dynamic>> activities,
  ) async {
    final fertilizerActivities =
        activities.where((a) => a['type'] == 'Fertilizing').toList();

    if (fertilizerActivities.isEmpty) {
      return;
    }

    // Group by crop
    final cropFertilization = <String, List<Map<String, dynamic>>>{};
    for (final activity in fertilizerActivities) {
      final crop = activity['crop'] as String? ?? 'Unknown';
      cropFertilization.putIfAbsent(crop, () => []);
      cropFertilization[crop]!.add(activity);
    }

    // Analyze each crop
    for (final entry in cropFertilization.entries) {
      final crop = entry.key;
      final applications = entry.value;

      // Check frequency
      if (applications.length >= 2) {
        final dates = applications
            .map((a) => DateTime.parse(
                a['date'] ?? a['timestamp'] ?? DateTime.now().toIso8601String()))
            .toList()
          ..sort();

        // Calculate average interval
        final intervals = <int>[];
        for (int i = 1; i < dates.length; i++) {
          intervals.add(dates[i].difference(dates[i - 1]).inDays);
        }

        if (intervals.isNotEmpty) {
          final avgInterval =
              intervals.reduce((a, b) => a + b) / intervals.length;

          // Over-fertilization check
          if (avgInterval < 20) {
            await _createOverfertilizationAlert(crop, avgInterval.round());
          }

          // Provide optimization tips
          if (avgInterval > 35 && avgInterval < 45) {
            await _createOptimalFertilizationInsight(crop, avgInterval.round());
          }
        }
      }
    }
  }

  /// Generate cost optimization recommendations
  static Future<void> _generateCostOptimizations(
    List<Map<String, dynamic>> activities,
    Map<String, dynamic>? analytics,
  ) async {
    if (activities.isEmpty) return;

    final last30Days = DateTime.now().subtract(const Duration(days: 30));
    final recentActivities = activities.where((a) {
      final date = DateTime.parse(
          a['date'] ?? a['timestamp'] ?? DateTime.now().toIso8601String());
      return date.isAfter(last30Days);
    }).toList();

    // Count resource-intensive activities
    final irrigation =
        recentActivities.where((a) => a['type'] == 'Irrigation').length;
    final fertilizing =
        recentActivities.where((a) => a['type'] == 'Fertilizing').length;
    final pestControl =
        recentActivities.where((a) => a['type'] == 'Pest Control').length;

    // Generate optimization opportunities
    if (irrigation > 30 || fertilizing > 4 || pestControl > 8) {
      await _createCostOptimizationDecision(
        irrigation,
        fertilizing,
        pestControl,
      );
    }

    // Efficiency insights
    await _generateEfficiencyInsights(recentActivities);
  }

  /// Generate sustainability recommendations
  static Future<void> _generateSustainabilityTips(
    List<Map<String, dynamic>> activities,
    String location,
  ) async {
    await _createSustainabilityInsight(
      'Sustainable Farming Practices',
      'Consider drip irrigation to save 40-60% water. Use organic compost to reduce chemical fertilizer dependency. Implement crop rotation for soil health.',
      ['drip_irrigation', 'organic_compost', 'crop_rotation'],
    );
  }

  /// Analyze irrigation timing for optimization
  static Future<void> _analyzeIrrigationTiming(
    List<Map<String, dynamic>> irrigations,
  ) async {
    // Best practice: Irrigate early morning or evening to minimize evaporation
    // If we had time-of-day data, we could analyze this
    // For now, provide general guidance

    await _createTimingOptimizationInsight(
      'Optimize Irrigation Timing',
      'Irrigate during early morning (6-8 AM) or evening (6-8 PM) to reduce water loss from evaporation by up to 30%.',
      'irrigation_timing',
    );
  }

  /// Generate efficiency insights
  static Future<void> _generateEfficiencyInsights(
    List<Map<String, dynamic>> activities,
  ) async {
    if (activities.length < 10) return;

    // Calculate activity efficiency score
    final uniqueTypes = activities.map((a) => a['type']).toSet().length;
    final totalActivities = activities.length;

    // Good balance of activity types indicates efficient management
    if (uniqueTypes >= 4 && totalActivities >= 15) {
      await _createEfficiencyInsight(
        'Well-Balanced Farm Management',
        'Your activity mix shows good farm management practices with $uniqueTypes different activity types. Keep maintaining this balance!',
        AgentPriority.low,
      );
    } else if (uniqueTypes < 3) {
      await _createEfficiencyInsight(
        'Diversify Farm Activities',
        'Consider expanding activity types. Balanced approach to irrigation, fertilizing, pest control, and weeding improves yields.',
        AgentPriority.medium,
      );
    }
  }

  // ==================== DECISION CREATORS ====================

  static Future<void> _createOverirrigationAlert(int count) async {
    final decision = AgentDecision(
      id: 'resource_overwater_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Excessive Irrigation Detected',
      message:
          'You have irrigated $count times in the past 30 days (${(count / 30).toStringAsFixed(1)} times/day). This may lead to waterlogging and water waste.',
      reasoning:
          'Excessive irrigation wastes water and can cause root diseases.',
      priority: AgentPriority.high,
      confidence: 0.85,
      data: {'irrigation_count': count, 'period_days': 30},
      actions: [
        'Check soil moisture before watering',
        'Reduce irrigation frequency',
        'Install drip irrigation',
        'Monitor for waterlogging'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createUnderirrigationAlert(int count) async {
    final decision = AgentDecision(
      id: 'resource_underwater_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Low Irrigation Frequency',
      message:
          'Only $count irrigation activities in past 30 days. Ensure crops are receiving adequate water for optimal growth.',
      reasoning:
          'Insufficient watering can stress plants and reduce yields.',
      priority: AgentPriority.medium,
      confidence: 0.7,
      data: {'irrigation_count': count, 'period_days': 30},
      actions: [
        'Check soil moisture levels',
        'Increase watering frequency',
        'Monitor crop health',
        'Consider climate conditions'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createOverfertilizationAlert(
      String crop, int avgInterval) async {
    final decision = AgentDecision(
      id: 'resource_overfert_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Over-Fertilization Risk',
      message:
          '$crop is being fertilized every $avgInterval days. This frequency may cause nutrient burn and environmental damage.',
      reasoning:
          'Excessive fertilization wastes money and harms soil and water.',
      priority: AgentPriority.high,
      confidence: 0.8,
      data: {'crop': crop, 'avg_interval': avgInterval},
      actions: [
        'Reduce fertilizer frequency',
        'Test soil nutrient levels',
        'Use slow-release fertilizers',
        'Follow recommended NPK ratios'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createCostOptimizationDecision(
    int irrigation,
    int fertilizing,
    int pestControl,
  ) async {
    final estimatedSavings = (irrigation * 50 + fertilizing * 500 + pestControl * 300) * 0.2;

    final decision = AgentDecision(
      id: 'resource_cost_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Cost Optimization Opportunity',
      message:
          'Optimize your resource usage to save approximately ₹${estimatedSavings.toStringAsFixed(0)} per month. Focus on water efficiency and integrated pest management.',
      reasoning:
          'Smart resource management reduces costs while maintaining yields.',
      priority: AgentPriority.medium,
      confidence: 0.75,
      data: {
        'irrigation_count': irrigation,
        'fertilizing_count': fertilizing,
        'pest_control_count': pestControl,
        'estimated_savings': estimatedSavings,
      },
      actions: [
        'Install drip irrigation system',
        'Use organic fertilizers',
        'Implement IPM practices',
        'Bulk buy inputs'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  // ==================== INSIGHT CREATORS ====================

  static Future<void> _createWaterUsageInsight(
    String title,
    String description,
    String action,
    AgentPriority priority,
  ) async {
    final insight = AgentInsight(
      id: 'resource_water_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: title,
      description: description,
      actionText: 'Learn More',
      actionData: {'focus': 'water', 'action': action},
      priority: priority,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createWaterConservationInsight() async {
    final insight = AgentInsight(
      id: 'resource_conservation_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Water Conservation Tips',
      description:
          'Save up to 50% water with these methods: Drip irrigation, mulching, proper timing, and soil moisture monitoring.',
      actionText: 'View Tips',
      actionData: {
        'tips': [
          'drip_irrigation',
          'mulching',
          'timing',
          'moisture_monitoring'
        ]
      },
      priority: AgentPriority.medium,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createOptimalFertilizationInsight(
      String crop, int avgInterval) async {
    final insight = AgentInsight(
      id: 'resource_optimal_fert_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Optimal Fertilization Schedule',
      description:
          'Your $crop fertilization schedule (every $avgInterval days) is well-optimized. This interval provides good nutrition without waste.',
      actionText: 'Continue Schedule',
      actionData: {'crop': crop, 'interval': avgInterval},
      priority: AgentPriority.low,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 14)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createTimingOptimizationInsight(
    String title,
    String description,
    String focus,
  ) async {
    final insight = AgentInsight(
      id: 'resource_timing_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: title,
      description: description,
      actionText: 'Set Reminders',
      actionData: {'focus': focus, 'optimal_times': ['06:00', '18:00']},
      priority: AgentPriority.low,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 14)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createSustainabilityInsight(
    String title,
    String description,
    List<String> practices,
  ) async {
    final insight = AgentInsight(
      id: 'resource_sustainability_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: title,
      description: description,
      actionText: 'Learn More',
      actionData: {'practices': practices, 'focus': 'sustainability'},
      priority: AgentPriority.medium,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createEfficiencyInsight(
    String title,
    String description,
    AgentPriority priority,
  ) async {
    final insight = AgentInsight(
      id: 'resource_efficiency_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: title,
      description: description,
      actionText: 'View Details',
      actionData: {'focus': 'efficiency'},
      priority: priority,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 14)),
    );

    await AgentService.saveInsight(insight);
  }

  /// Schedule regular resource analysis
  static Future<void> scheduleAnalysis() async {
    final task = AgentTask(
      id: 'resource_analysis_${DateTime.now().millisecondsSinceEpoch}',
      type: agentType,
      name: 'Resource Analysis',
      description: 'Analyze resource usage and generate optimization tips',
      context: {},
      scheduledTime: DateTime.now().add(const Duration(days: 7)),
      priority: AgentPriority.low,
      status: AgentTaskStatus.pending,
      createdAt: DateTime.now(),
    );

    await AgentService.scheduleTask(task);
  }
}
