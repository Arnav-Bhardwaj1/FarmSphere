import 'package:flutter/foundation.dart';
import '../models/agent_models.dart';
import '../services/agent_service.dart';
import '../services/agent_database.dart';

/// Crop Health Monitoring Agent - Detects patterns and provides preventive recommendations
class CropHealthAgent {
  static const AgentType agentType = AgentType.cropHealth;

  /// Analyze crop health history and detect patterns
  static Future<void> analyze({
    required List<Map<String, dynamic>> diagnosisHistory,
    required String location,
    String? userId,
  }) async {
    if (kDebugMode) {
      print('CropHealthAgent: Starting analysis');
    }

    try {
      // Check if agent is enabled
      final isEnabled = await AgentDatabase.isAgentEnabled(agentType);
      if (!isEnabled) {
        if (kDebugMode) {
          print('CropHealthAgent: Agent is disabled');
        }
        return;
      }

      // Analyze disease patterns
      await _analyzeDiseasePatterns(diagnosisHistory);

      // Check for recurring issues
      await _checkRecurringIssues(diagnosisHistory);

      // Generate preventive recommendations
      await _generatePreventiveRecommendations(diagnosisHistory, location);

      // Suggest monitoring schedule
      await _suggestMonitoringSchedule(diagnosisHistory);

      if (kDebugMode) {
        print('CropHealthAgent: Analysis completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('CropHealthAgent: Error during analysis - $e');
      }
    }
  }

  /// Analyze disease patterns in history
  static Future<void> _analyzeDiseasePatterns(
    List<Map<String, dynamic>> history,
  ) async {
    if (history.isEmpty) return;

    // Group diagnoses by disease
    final diseaseGroups = <String, List<Map<String, dynamic>>>{};
    for (final diagnosis in history) {
      final disease = diagnosis['disease'] as String? ??
          (diagnosis['results'] is List && (diagnosis['results'] as List).isNotEmpty
              ? (diagnosis['results'][0]['label'] as String? ?? 'Unknown')
              : 'Unknown');

      diseaseGroups.putIfAbsent(disease, () => []);
      diseaseGroups[disease]!.add(diagnosis);
    }

    // Analyze each disease
    for (final entry in diseaseGroups.entries) {
      final disease = entry.key;
      final occurrences = entry.value;

      if (occurrences.length >= 2) {
        // Check if disease is recurring
        final dates = occurrences.map((d) {
          return DateTime.parse(
              d['timestamp'] ?? d['date'] ?? DateTime.now().toIso8601String());
        }).toList()
          ..sort();

        // Calculate average time between occurrences
        if (dates.length >= 2) {
          final intervals = <int>[];
          for (int i = 1; i < dates.length; i++) {
            intervals.add(dates[i].difference(dates[i - 1]).inDays);
          }

          final avgInterval =
              intervals.reduce((a, b) => a + b) / intervals.length;

          await _createRecurringDiseaseAlert(
              disease, occurrences.length, avgInterval.round());
        }
      }
    }
  }

  /// Check for recurring crop health issues
  static Future<void> _checkRecurringIssues(
    List<Map<String, dynamic>> history,
  ) async {
    if (history.length < 3) return;

    // Get recent diagnoses (last 30 days)
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final recentDiagnoses = history.where((d) {
      final date = DateTime.parse(
          d['timestamp'] ?? d['date'] ?? DateTime.now().toIso8601String());
      return date.isAfter(thirtyDaysAgo);
    }).toList();

    if (recentDiagnoses.length >= 3) {
      await _createFrequentIssuesAlert(recentDiagnoses.length);
    }

    // Check severity trends
    final highSeverityCount = recentDiagnoses.where((d) {
      final severity = d['severity'] as String? ?? 'Unknown';
      return severity.toLowerCase() == 'high' ||
          severity.toLowerCase() == 'severe';
    }).length;

    if (highSeverityCount >= 2) {
      await _createSeverityTrendAlert(highSeverityCount);
    }
  }

  /// Generate preventive recommendations based on history
  static Future<void> _generatePreventiveRecommendations(
    List<Map<String, dynamic>> history,
    String location,
  ) async {
    if (history.isEmpty) {
      await _createInitialPreventionInsight();
      return;
    }

    // Analyze most common diseases
    final diseaseFrequency = <String, int>{};
    for (final diagnosis in history) {
      final disease = diagnosis['disease'] as String? ??
          (diagnosis['results'] is List && (diagnosis['results'] as List).isNotEmpty
              ? (diagnosis['results'][0]['label'] as String? ?? 'Unknown')
              : 'Unknown');

      diseaseFrequency[disease] = (diseaseFrequency[disease] ?? 0) + 1;
    }

    // Get top 3 most common diseases
    final topDiseases = diseaseFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in topDiseases.take(3)) {
      await _createDiseasePreventionInsight(entry.key, entry.value);
    }

    // Seasonal recommendations
    await _generateSeasonalHealthTips(location);
  }

  /// Suggest monitoring schedule
  static Future<void> _suggestMonitoringSchedule(
    List<Map<String, dynamic>> history,
  ) async {
    if (history.isEmpty) {
      await _createMonitoringScheduleInsight(
        'Start Regular Crop Monitoring',
        'Schedule weekly crop health checks to catch issues early. Early detection can prevent major crop losses.',
        7,
      );
      return;
    }

    // Check last diagnosis date
    final lastDiagnosis = history.fold<DateTime?>(null, (prev, diagnosis) {
      final date = DateTime.parse(
          diagnosis['timestamp'] ?? diagnosis['date'] ?? DateTime.now().toIso8601String());
      return prev == null || date.isAfter(prev) ? date : prev;
    });

    if (lastDiagnosis != null) {
      final daysSince = DateTime.now().difference(lastDiagnosis).inDays;

      if (daysSince >= 14) {
        await _createMonitoringReminderDecision(daysSince);
      } else if (daysSince >= 7) {
        await _createMonitoringScheduleInsight(
          'Schedule Crop Health Check',
          'It has been $daysSince days since your last crop health scan. Regular monitoring helps maintain healthy crops.',
          daysSince,
        );
      }
    }
  }

  /// Generate seasonal health tips
  static Future<void> _generateSeasonalHealthTips(String location) async {
    final month = DateTime.now().month;

    String title;
    String tips;
    List<String> focus;

    if (month >= 6 && month <= 9) {
      // Monsoon season
      title = 'Monsoon Disease Prevention';
      tips =
          'High humidity during monsoon increases fungal disease risk. Monitor for leaf spots, blight, and mildew. Ensure good drainage and air circulation.';
      focus = ['fungal_prevention', 'drainage', 'humidity_control'];
    } else if (month >= 3 && month <= 5) {
      // Summer season
      title = 'Summer Crop Protection';
      tips =
          'Hot weather can stress crops and increase pest activity. Watch for heat damage, spider mites, and aphids. Ensure adequate watering.';
      focus = ['heat_stress', 'pest_control', 'irrigation'];
    } else if (month >= 10 && month <= 11) {
      // Post-monsoon
      title = 'Post-Monsoon Care';
      tips =
          'Monitor for bacterial infections and root diseases after monsoon. Check for waterlogged conditions and improve soil drainage if needed.';
      focus = ['bacterial_prevention', 'root_health', 'drainage'];
    } else {
      // Winter season
      title = 'Winter Crop Health';
      tips =
          'Cold weather can slow growth and increase disease susceptibility. Protect from frost, monitor for powdery mildew, and ensure proper nutrition.';
      focus = ['frost_protection', 'nutrition', 'disease_monitoring'];
    }

    await _createSeasonalHealthInsight(title, tips, focus);
  }

  // ==================== DECISION CREATORS ====================

  static Future<void> _createRecurringDiseaseAlert(
    String disease,
    int occurrences,
    int avgInterval,
  ) async {
    final decision = AgentDecision(
      id: 'crop_recurring_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Recurring Disease Detected',
      message:
          '$disease has occurred $occurrences times, typically every $avgInterval days. Consider preventive measures to break this cycle.',
      reasoning:
          'Recurring diseases indicate underlying environmental or management issues that need addressing.',
      priority: AgentPriority.high,
      confidence: 0.85,
      data: {
        'disease': disease,
        'occurrences': occurrences,
        'avg_interval': avgInterval,
      },
      actions: [
        'Review prevention methods',
        'Improve sanitation',
        'Consider resistant varieties',
        'Adjust irrigation'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createFrequentIssuesAlert(int issueCount) async {
    final decision = AgentDecision(
      id: 'crop_frequent_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Frequent Crop Health Issues',
      message:
          'You have had $issueCount crop health issues in the past 30 days. This suggests environmental stress or management practices need adjustment.',
      reasoning:
          'Frequent health issues indicate systemic problems requiring comprehensive solutions.',
      priority: AgentPriority.high,
      confidence: 0.8,
      data: {'issue_count': issueCount, 'period_days': 30},
      actions: [
        'Review irrigation practices',
        'Check soil health',
        'Improve crop spacing',
        'Consult expert'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createSeverityTrendAlert(int highSeverityCount) async {
    final decision = AgentDecision(
      id: 'crop_severity_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Increasing Disease Severity',
      message:
          '$highSeverityCount high-severity issues detected recently. Early intervention is crucial to prevent crop loss.',
      reasoning:
          'Increasing severity suggests diseases are progressing unchecked or conditions are worsening.',
      priority: AgentPriority.critical,
      confidence: 0.9,
      data: {'high_severity_count': highSeverityCount},
      actions: [
        'Apply treatment immediately',
        'Isolate affected plants',
        'Increase monitoring frequency',
        'Seek expert advice'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createMonitoringReminderDecision(int daysSince) async {
    final decision = AgentDecision(
      id: 'crop_monitoring_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Crop Health Check Overdue',
      message:
          'It has been $daysSince days since your last crop health scan. Regular monitoring helps catch problems early.',
      reasoning:
          'Regular monitoring is essential for early disease detection and prevention.',
      priority: AgentPriority.medium,
      confidence: 0.85,
      data: {'days_since': daysSince},
      actions: ['Scan crops now', 'Schedule regular checks', 'Set reminders'],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  // ==================== INSIGHT CREATORS ====================

  static Future<void> _createDiseasePreventionInsight(
    String disease,
    int occurrences,
  ) async {
    final preventionTips = _getPreventionTips(disease);

    final insight = AgentInsight(
      id: 'crop_prevention_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Prevent $disease',
      description:
          'You have experienced $disease $occurrences time${occurrences > 1 ? 's' : ''}. $preventionTips',
      actionText: 'View Prevention Guide',
      actionData: {'disease': disease, 'occurrences': occurrences},
      priority: AgentPriority.medium,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createInitialPreventionInsight() async {
    final insight = AgentInsight(
      id: 'crop_initial_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Start Crop Health Monitoring',
      description:
          'Regular crop health checks help detect diseases early. Use the crop health scanner to monitor your plants and get AI-powered recommendations.',
      actionText: 'Scan Crops',
      actionData: {'action': 'start_monitoring'},
      priority: AgentPriority.medium,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createMonitoringScheduleInsight(
    String title,
    String description,
    int daysSince,
  ) async {
    final insight = AgentInsight(
      id: 'crop_schedule_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: title,
      description: description,
      actionText: 'Scan Now',
      actionData: {'days_since': daysSince, 'action': 'scan'},
      priority: daysSince >= 14 ? AgentPriority.medium : AgentPriority.low,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 3)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createSeasonalHealthInsight(
    String title,
    String tips,
    List<String> focus,
  ) async {
    final insight = AgentInsight(
      id: 'crop_seasonal_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: title,
      description: tips,
      actionText: 'Learn More',
      actionData: {'focus_areas': focus, 'season': _getSeason()},
      priority: AgentPriority.medium,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await AgentService.saveInsight(insight);
  }

  // ==================== HELPER METHODS ====================

  /// Get prevention tips for specific diseases
  static String _getPreventionTips(String disease) {
    final tips = {
      'Leaf Blight': 'Improve air circulation, avoid overhead watering, and remove infected leaves promptly.',
      'Powdery Mildew':
          'Ensure good air flow, reduce humidity, and apply sulfur-based fungicides preventively.',
      'Bacterial Spot':
          'Use disease-free seeds, practice crop rotation, and avoid working with wet plants.',
      'Early Blight': 'Mulch around plants, water at soil level, and remove lower leaves.',
      'Late Blight':
          'Monitor weather conditions, improve drainage, and apply copper-based fungicides.',
      'Fusarium Wilt': 'Use resistant varieties, practice crop rotation, and improve soil drainage.',
      'Root Rot': 'Avoid overwatering, improve soil drainage, and use well-draining soil mix.',
      'Aphid Infestation':
          'Encourage beneficial insects, use neem oil spray, and remove heavily infested parts.',
      'Spider Mites': 'Increase humidity, spray with water regularly, and use miticides if severe.',
    };

    return tips[disease] ??
        'Practice good sanitation, monitor regularly, and maintain optimal growing conditions.';
  }

  /// Get current season
  static String _getSeason() {
    final month = DateTime.now().month;
    if (month >= 6 && month <= 9) return 'Monsoon';
    if (month >= 3 && month <= 5) return 'Summer';
    if (month >= 10 && month <= 11) return 'Post-Monsoon';
    return 'Winter';
  }

  /// Schedule regular crop health analysis
  static Future<void> scheduleAnalysis() async {
    final task = AgentTask(
      id: 'crop_health_analysis_${DateTime.now().millisecondsSinceEpoch}',
      type: agentType,
      name: 'Crop Health Analysis',
      description: 'Analyze crop health history and detect patterns',
      context: {},
      scheduledTime: DateTime.now().add(const Duration(days: 1)),
      priority: AgentPriority.medium,
      status: AgentTaskStatus.pending,
      createdAt: DateTime.now(),
    );

    await AgentService.scheduleTask(task);
  }
}
