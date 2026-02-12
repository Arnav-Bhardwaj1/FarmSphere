import 'package:flutter/foundation.dart';
import '../models/agent_models.dart';
import '../services/agent_service.dart';
import '../services/agent_database.dart';

/// Activity Scheduling Agent - Suggests farming activities based on patterns and conditions
class ActivityAgent {
  static const AgentType agentType = AgentType.activity;

  /// Analyze activity history and generate scheduling recommendations
  static Future<void> analyze({
    required List<Map<String, dynamic>> activityHistory,
    required Map<String, dynamic>? weatherData,
    required String location,
    String? userId,
  }) async {
    if (kDebugMode) {
      print('ActivityAgent: Starting analysis');
    }

    try {
      // Check if agent is enabled
      final isEnabled = await AgentDatabase.isAgentEnabled(agentType);
      if (!isEnabled) {
        if (kDebugMode) {
          print('ActivityAgent: Agent is disabled');
        }
        return;
      }

      // Analyze activity patterns
      await _analyzeActivityPatterns(activityHistory);

      // Generate crop-specific recommendations
      await _generateCropRecommendations(activityHistory, weatherData);

      // Check for missed activities
      await _checkMissedActivities(activityHistory);

      // Generate seasonal recommendations
      await _generateSeasonalRecommendations(weatherData, location);

      // Generate irrigation schedule
      await _generateIrrigationSchedule(activityHistory, weatherData);

      if (kDebugMode) {
        print('ActivityAgent: Analysis completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ActivityAgent: Error during analysis - $e');
      }
    }
  }

  /// Analyze patterns in activity history
  static Future<void> _analyzeActivityPatterns(
    List<Map<String, dynamic>> activities,
  ) async {
    if (activities.isEmpty) return;

    // Group activities by type
    final activityGroups = <String, List<Map<String, dynamic>>>{};
    for (final activity in activities) {
      final type = activity['type'] as String? ?? 'Unknown';
      activityGroups.putIfAbsent(type, () => []);
      activityGroups[type]!.add(activity);
    }

    // Analyze each activity type
    for (final entry in activityGroups.entries) {
      final type = entry.key;
      final typeActivities = entry.value;

      // Calculate average interval between activities
      if (typeActivities.length >= 2) {
        final intervals = <int>[];
        for (int i = 1; i < typeActivities.length; i++) {
          final prev = DateTime.parse(
              typeActivities[i - 1]['date'] ?? typeActivities[i - 1]['timestamp']);
          final current = DateTime.parse(
              typeActivities[i]['date'] ?? typeActivities[i]['timestamp']);
          intervals.add(current.difference(prev).inDays.abs());
        }

        if (intervals.isNotEmpty) {
          final avgInterval =
              intervals.reduce((a, b) => a + b) / intervals.length;
          await _generateActivityReminderInsight(type, avgInterval.round());
        }
      }
    }
  }

  /// Generate crop-specific recommendations
  static Future<void> _generateCropRecommendations(
    List<Map<String, dynamic>> activities,
    Map<String, dynamic>? weatherData,
  ) async {
    // Get unique crops from activities
    final crops = <String>{};
    for (final activity in activities) {
      final crop = activity['crop'] as String?;
      if (crop != null && crop.isNotEmpty) {
        crops.add(crop);
      }
    }

    // Generate recommendations for each crop
    for (final crop in crops) {
      // Get last activity for this crop
      final cropActivities = activities
          .where((a) => a['crop'] == crop)
          .toList()
        ..sort((a, b) {
          final dateA =
              DateTime.parse(a['date'] ?? a['timestamp'] ?? DateTime.now().toIso8601String());
          final dateB =
              DateTime.parse(b['date'] ?? b['timestamp'] ?? DateTime.now().toIso8601String());
          return dateB.compareTo(dateA);
        });

      if (cropActivities.isEmpty) continue;

      final lastActivity = cropActivities.first;
      final lastDate = DateTime.parse(
          lastActivity['date'] ?? lastActivity['timestamp'] ?? DateTime.now().toIso8601String());
      final daysSinceLastActivity = DateTime.now().difference(lastDate).inDays;

      // Generate recommendations based on crop and time elapsed
      await _generateCropSpecificAdvice(crop, daysSinceLastActivity, weatherData);
    }
  }

  /// Generate crop-specific advice
  static Future<void> _generateCropSpecificAdvice(
    String crop,
    int daysSinceActivity,
    Map<String, dynamic>? weatherData,
  ) async {
    // Crop-specific schedules (simplified)
    final schedules = {
      'Rice': {
        'Fertilizing': 30,
        'Irrigation': 7,
        'Pest Control': 14,
        'Weeding': 21,
      },
      'Wheat': {
        'Fertilizing': 35,
        'Irrigation': 10,
        'Pest Control': 21,
        'Weeding': 28,
      },
      'Tomato': {
        'Fertilizing': 14,
        'Irrigation': 2,
        'Pest Control': 7,
        'Pruning': 10,
      },
      'Potato': {
        'Fertilizing': 21,
        'Irrigation': 5,
        'Pest Control': 14,
        'Hilling': 30,
      },
    };

    final cropSchedule = schedules[crop] ?? schedules['Rice'];

    for (final entry in cropSchedule!.entries) {
      final activityType = entry.key;
      final recommendedInterval = entry.value;

      if (daysSinceActivity >= recommendedInterval) {
        await _createActivityRecommendation(crop, activityType, daysSinceActivity);
      }
    }
  }

  /// Check for missed or overdue activities
  static Future<void> _checkMissedActivities(
    List<Map<String, dynamic>> activities,
  ) async {
    // Common farming activity intervals (in days)
    final criticalIntervals = {
      'Irrigation': 7,
      'Fertilizing': 30,
      'Pest Control': 21,
    };

    for (final entry in criticalIntervals.entries) {
      final activityType = entry.key;
      final maxInterval = entry.value;

      // Find last occurrence of this activity
      final lastActivity = activities
          .where((a) => a['type'] == activityType)
          .fold<DateTime?>(null, (prev, activity) {
        final date = DateTime.parse(
            activity['date'] ?? activity['timestamp'] ?? DateTime.now().toIso8601String());
        return prev == null || date.isAfter(prev) ? date : prev;
      });

      if (lastActivity != null) {
        final daysSince = DateTime.now().difference(lastActivity).inDays;
        if (daysSince > maxInterval) {
          await _createMissedActivityAlert(activityType, daysSince);
        }
      }
    }
  }

  /// Generate seasonal farming recommendations
  static Future<void> _generateSeasonalRecommendations(
    Map<String, dynamic>? weatherData,
    String location,
  ) async {
    final month = DateTime.now().month;
    final season = _getSeason(month);

    switch (season) {
      case 'Summer':
        await _createSeasonalInsight(
          'Summer Farming Tips',
          'Increase irrigation frequency, provide shade for sensitive crops, and monitor for heat stress. Consider mulching to retain soil moisture.',
          ['irrigation', 'heat_protection', 'mulching'],
        );
        break;
      case 'Monsoon':
        await _createSeasonalInsight(
          'Monsoon Preparation',
          'Ensure proper drainage, watch for fungal diseases, and reduce irrigation. This is a good time for planting rice and monsoon vegetables.',
          ['drainage', 'disease_prevention', 'monsoon_planting'],
        );
        break;
      case 'Winter':
        await _createSeasonalInsight(
          'Winter Crop Care',
          'Protect crops from frost, adjust irrigation schedules, and consider winter crop varieties. Good time for planting wheat and winter vegetables.',
          ['frost_protection', 'winter_planting'],
        );
        break;
      case 'Spring':
        await _createSeasonalInsight(
          'Spring Planting Season',
          'Prepare soil for planting, consider crop rotation, and plan your summer crop schedule. Optimal time for most vegetable planting.',
          ['soil_preparation', 'crop_rotation', 'planting'],
        );
        break;
    }
  }

  /// Get season from month
  static String _getSeason(int month) {
    if (month >= 3 && month <= 5) return 'Summer';
    if (month >= 6 && month <= 9) return 'Monsoon';
    if (month >= 10 && month <= 11) return 'Winter';
    return 'Spring';
  }

  /// Generate irrigation schedule based on weather and past patterns
  static Future<void> _generateIrrigationSchedule(
    List<Map<String, dynamic>> activities,
    Map<String, dynamic>? weatherData,
  ) async {
    final irrigationActivities =
        activities.where((a) => a['type'] == 'Irrigation').toList();

    if (irrigationActivities.isEmpty) {
      // No history, suggest based on weather
      if (weatherData != null) {
        final temp = weatherData['temperature'] as int? ?? 0;
        if (temp > 30) {
          await _createIrrigationInsight(
            'Start Regular Irrigation',
            'High temperatures require regular watering. Consider irrigating every 2-3 days based on your crops.',
            AgentPriority.high,
          );
        }
      }
      return;
    }

    // Find last irrigation
    final lastIrrigation = irrigationActivities.fold<DateTime?>(null, (prev, activity) {
      final date = DateTime.parse(
          activity['date'] ?? activity['timestamp'] ?? DateTime.now().toIso8601String());
      return prev == null || date.isAfter(prev) ? date : prev;
    });

    if (lastIrrigation != null) {
      final daysSince = DateTime.now().difference(lastIrrigation).inDays;

      // Check weather conditions
      if (weatherData != null) {
        final temp = weatherData['temperature'] as int? ?? 0;

        // Hot weather needs more frequent irrigation
        if (temp > 35 && daysSince >= 2) {
          await _createIrrigationInsight(
            'Irrigation Needed',
            'High temperatures and $daysSince days since last watering. Your crops may need water.',
            AgentPriority.high,
          );
        } else if (temp > 25 && daysSince >= 5) {
          await _createIrrigationInsight(
            'Consider Irrigation',
            'It has been $daysSince days since last watering. Check soil moisture levels.',
            AgentPriority.medium,
          );
        }
      }
    }
  }

  // ==================== DECISION CREATORS ====================

  static Future<void> _createActivityRecommendation(
    String crop,
    String activityType,
    int daysSince,
  ) async {
    final decision = AgentDecision(
      id: 'activity_rec_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: '$activityType Recommended for $crop',
      message:
          'It has been $daysSince days since your last $crop activity. Consider $activityType for optimal crop health.',
      reasoning: 'Regular $activityType is important for $crop at this growth stage.',
      priority: daysSince > 45 ? AgentPriority.high : AgentPriority.medium,
      confidence: 0.8,
      data: {
        'crop': crop,
        'activity_type': activityType,
        'days_since': daysSince,
      },
      actions: ['Schedule $activityType', 'View crop calendar', 'Add to activities'],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createMissedActivityAlert(
    String activityType,
    int daysSince,
  ) async {
    final decision = AgentDecision(
      id: 'activity_missed_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Overdue: $activityType',
      message:
          'Your $activityType is overdue by $daysSince days. This may affect crop health and yield.',
      reasoning: 'Regular maintenance activities are crucial for crop success.',
      priority: AgentPriority.high,
      confidence: 0.85,
      data: {
        'activity_type': activityType,
        'days_overdue': daysSince,
      },
      actions: [
        'Schedule immediately',
        'Mark as completed',
        'Update schedule'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  // ==================== INSIGHT CREATORS ====================

  static Future<void> _generateActivityReminderInsight(
    String activityType,
    int avgInterval,
  ) async {
    final insight = AgentInsight(
      id: 'activity_reminder_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Learned Your $activityType Pattern',
      description:
          'Based on your history, you typically perform $activityType every $avgInterval days. I will remind you automatically.',
      actionText: 'View Schedule',
      actionData: {
        'activity_type': activityType,
        'interval': avgInterval,
      },
      priority: AgentPriority.low,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createSeasonalInsight(
    String title,
    String description,
    List<String> tags,
  ) async {
    final insight = AgentInsight(
      id: 'activity_seasonal_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: title,
      description: description,
      actionText: 'View Recommendations',
      actionData: {'tags': tags, 'season': _getSeason(DateTime.now().month)},
      priority: AgentPriority.medium,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createIrrigationInsight(
    String title,
    String description,
    AgentPriority priority,
  ) async {
    final insight = AgentInsight(
      id: 'activity_irrigation_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: title,
      description: description,
      actionText: 'Schedule Irrigation',
      actionData: {'activity_type': 'Irrigation'},
      priority: priority,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    await AgentService.saveInsight(insight);
  }

  /// Schedule regular activity analysis
  static Future<void> scheduleAnalysis() async {
    // Schedule analysis twice daily (morning and evening)
    final now = DateTime.now();
    final morningTime = DateTime(now.year, now.month, now.day, 8, 0);
    final eveningTime = DateTime(now.year, now.month, now.day, 18, 0);

    DateTime nextRun;
    if (now.isBefore(morningTime)) {
      nextRun = morningTime;
    } else if (now.isBefore(eveningTime)) {
      nextRun = eveningTime;
    } else {
      nextRun = morningTime.add(const Duration(days: 1));
    }

    final task = AgentTask(
      id: 'activity_analysis_${DateTime.now().millisecondsSinceEpoch}',
      type: agentType,
      name: 'Activity Analysis',
      description: 'Analyze activity patterns and generate recommendations',
      context: {},
      scheduledTime: nextRun,
      priority: AgentPriority.medium,
      status: AgentTaskStatus.pending,
      createdAt: DateTime.now(),
    );

    await AgentService.scheduleTask(task);
  }
}
