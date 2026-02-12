import 'package:flutter/foundation.dart';
import '../models/agent_models.dart';
import 'agent_database.dart';
import 'agent_notification_service.dart';
import 'background_task_service.dart';
import 'agent_mock_data.dart';

/// Main service for managing all AI agents
class AgentService {
  static bool _initialized = false;
  static bool _mockDataInitialized = false;

  /// Initialize the agent service
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Check if running on web platform
      if (kIsWeb) {
        if (kDebugMode) {
          print('AgentService: Web platform detected - database features disabled');
        }
        _initialized = true;
        return;
      }

      // Initialize database
      await AgentDatabase.database;

      // Initialize notification service
      await AgentNotificationService.initialize();

      // Request notification permissions
      await AgentNotificationService.requestPermissions();

      // Initialize background tasks
      await BackgroundTaskService.initialize();

      // Initialize default settings for all agents
      await _initializeDefaultSettings();

      // Register background tasks
      await BackgroundTaskService.registerAgentTasks();

      // Initialize mock data for demo (only once)
      if (!_mockDataInitialized) {
        await _initializeMockData();
        _mockDataInitialized = true;
      }

      _initialized = true;

      if (kDebugMode) {
        print('AgentService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing AgentService: $e');
      }
    }
  }

  /// Initialize default settings for all agents
  static Future<void> _initializeDefaultSettings() async {
    for (final agentType in AgentType.values) {
      final existing = await AgentDatabase.getSettings(agentType);
      if (existing == null) {
        await AgentDatabase.saveSettings(AgentSettings(
          agentType: agentType,
          enabled: true,
          preferences: _getDefaultPreferences(agentType),
          lastUpdated: DateTime.now(),
        ));
      }
    }
  }

  /// Get default preferences for an agent type
  static Map<String, dynamic> _getDefaultPreferences(AgentType agentType) {
    switch (agentType) {
      case AgentType.weather:
        return {
          'check_interval_minutes': 30,
          'alert_before_hours': 6,
          'min_priority': AgentPriority.medium.index,
        };
      case AgentType.cropHealth:
        return {
          'check_interval_hours': 24,
          'pattern_lookback_days': 30,
          'min_confidence': 0.7,
        };
      case AgentType.activity:
        return {
          'check_times': ['08:00', '18:00'], // Morning and evening
          'reminder_before_hours': 24,
          'learn_from_history': true,
        };
      case AgentType.market:
        return {
          'check_interval_hours': 4,
          'price_change_threshold': 0.1, // 10% change
          'track_crops': [],
        };
      case AgentType.resource:
        return {
          'check_interval_days': 7,
          'optimization_focus': ['water', 'fertilizer'],
        };
    }
  }

  /// Enable or disable an agent
  static Future<void> setAgentEnabled(AgentType agentType, bool enabled) async {
    if (kIsWeb) {
      if (kDebugMode) {
        print('AgentService: Cannot toggle agents on web platform');
      }
      return;
    }
    final settings = await AgentDatabase.getSettings(agentType);
    if (settings != null) {
      await AgentDatabase.saveSettings(settings.copyWith(
        enabled: enabled,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Update agent preferences
  static Future<void> updateAgentPreferences(
    AgentType agentType,
    Map<String, dynamic> preferences,
  ) async {
    final settings = await AgentDatabase.getSettings(agentType);
    if (settings != null) {
      await AgentDatabase.saveSettings(settings.copyWith(
        preferences: preferences,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Get agent status
  static Future<Map<AgentType, bool>> getAgentStatuses() async {
    if (kIsWeb) {
      // Return default statuses for web platform
      return Map.fromEntries(
        AgentType.values.map((type) => MapEntry(type, false)),
      );
    }
    final statuses = <AgentType, bool>{};
    for (final agentType in AgentType.values) {
      statuses[agentType] = await AgentDatabase.isAgentEnabled(agentType);
    }
    return statuses;
  }

  /// Schedule an agent task
  static Future<void> scheduleTask(AgentTask task) async {
    await AgentDatabase.insertTask(task);

    // If task is due soon, schedule immediate background execution
    final minutesUntilDue = task.scheduledTime.difference(DateTime.now()).inMinutes;
    if (minutesUntilDue < 30 && minutesUntilDue > 0) {
      await BackgroundTaskService.scheduleOneTimeTask(
        uniqueName: 'task_${task.id}',
        taskName: 'agent_task_execution',
        delay: Duration(minutes: minutesUntilDue),
        inputData: {'task_id': task.id},
      );
    }
  }

  /// Create and save an agent decision
  static Future<void> saveDecision(AgentDecision decision) async {
    await AgentDatabase.insertDecision(decision);

    // Send notification for high priority decisions
    if (decision.priority == AgentPriority.high ||
        decision.priority == AgentPriority.critical) {
      await AgentNotificationService.notifyDecision(decision);
    }
  }

  /// Create and save an agent insight
  static Future<void> saveInsight(AgentInsight insight) async {
    await AgentDatabase.insertInsight(insight);

    // Send notification for high priority insights
    if (insight.priority == AgentPriority.high ||
        insight.priority == AgentPriority.critical) {
      await AgentNotificationService.notifyInsight(insight);
    }
  }

  /// Get active insights for display
  static Future<List<AgentInsight>> getActiveInsights() async {
    if (kIsWeb) return [];
    return await AgentDatabase.getActiveInsights();
  }

  /// Get recent decisions
  static Future<List<AgentDecision>> getRecentDecisions({int limit = 20}) async {
    if (kIsWeb) return [];
    return await AgentDatabase.getRecentDecisions(limit: limit);
  }

  /// Get unacknowledged decisions
  static Future<List<AgentDecision>> getUnacknowledgedDecisions() async {
    if (kIsWeb) return [];
    return await AgentDatabase.getUnacknowledgedDecisions();
  }

  /// Acknowledge a decision
  static Future<void> acknowledgeDecision(String decisionId) async {
    if (kIsWeb) return;
    await AgentDatabase.acknowledgeDecision(decisionId);
  }

  /// Dismiss an insight
  static Future<void> dismissInsight(String insightId) async {
    if (kIsWeb) return;
    await AgentDatabase.dismissInsight(insightId);
  }

  /// Get notification history
  static Future<List<AgentNotification>> getNotificationHistory({int limit = 50}) async {
    return await AgentDatabase.getNotificationHistory(limit: limit);
  }

  /// Run agents immediately (for testing)
  static Future<void> runAgentsNow() async {
    if (kIsWeb) {
      if (kDebugMode) {
        print('AgentService: Run now not supported on web platform');
      }
      throw UnsupportedError('Agent execution is not supported on web platform. Please use the mobile or desktop app.');
    }
    await BackgroundTaskService.executeAgentTasksNow();
  }

  /// Check and send pending notifications
  static Future<void> checkNotifications() async {
    await AgentNotificationService.checkAndSendPending();
  }

  /// Perform maintenance
  static Future<void> performMaintenance() async {
    await AgentDatabase.performMaintenance();
  }

  /// Get agent statistics
  static Future<Map<String, dynamic>> getStatistics() async {
    if (kIsWeb) {
      return {
        'pending_tasks': 0,
        'recent_decisions': 0,
        'active_insights': 0,
        'notifications_sent': 0,
        'unacknowledged_decisions': 0,
        'agents_enabled': 0,
      };
    }
    final tasks = await AgentDatabase.getPendingTasks();
    final decisions = await AgentDatabase.getRecentDecisions(limit: 100);
    final insights = await AgentDatabase.getActiveInsights();
    final notifications = await AgentDatabase.getNotificationHistory(limit: 100);

    return {
      'pending_tasks': tasks.length,
      'recent_decisions': decisions.length,
      'active_insights': insights.length,
      'notifications_sent': notifications.where((n) => n.sent).length,
      'unacknowledged_decisions':
          decisions.where((d) => !d.acknowledged).length,
      'agents_enabled':
          (await getAgentStatuses()).values.where((enabled) => enabled).length,
    };
  }

  /// Reset all agent data (for testing/debugging)
  static Future<void> resetAllData() async {
    if (kDebugMode) {
      await AgentDatabase.close();
      // Database will be recreated on next access
      _initialized = false;
      await initialize();
      print('Agent data reset');
    }
  }

  /// Send a test notification
  static Future<void> sendTestNotification() async {
    await AgentNotificationService.sendTestNotification();
  }

  /// Initialize mock data for demonstration
  static Future<void> _initializeMockData() async {
    if (kIsWeb) return; // Skip on web
    
    try {
      // Check if we already have decisions (avoid duplicates)
      final existingDecisions = await AgentDatabase.getRecentDecisions(limit: 1);
      if (existingDecisions.isEmpty) {
        if (kDebugMode) {
          print('Initializing mock agent data for demonstration...');
        }
        await AgentMockData.initializeMockData();
        if (kDebugMode) {
          print('Mock data initialized successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing mock data: $e');
      }
    }
  }
}
