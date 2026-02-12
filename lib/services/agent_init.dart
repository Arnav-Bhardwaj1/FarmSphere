import 'package:flutter/foundation.dart';
import 'agent_service.dart';
import 'agent_decision_engine.dart';
import 'agent_notification_service.dart';
import 'background_task_service.dart';
import 'data_cleanup_service.dart';

/// Helper class to initialize the agent system
class AgentInit {
  static bool _initialized = false;

  /// Initialize the complete agent system
  /// Call this from main.dart after app initialization
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      if (kDebugMode) {
        print('Initializing FarmSphere AI Agent System...');
      }

      // Initialize core services
      await AgentService.initialize();
      await AgentDecisionEngine.initialize();
      await AgentNotificationService.initialize();
      await BackgroundTaskService.initialize();
      
      // Initialize data cleanup service
      await DataCleanupService.initialize();

      // Register background tasks
      await BackgroundTaskService.registerAgentTasks();
      
      // Check if cleanup is needed
      if (await DataCleanupService.shouldRunCleanup()) {
        // Run cleanup in background
        DataCleanupService.cleanupOldData();
      }

      _initialized = true;

      if (kDebugMode) {
        print('FarmSphere AI Agent System initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Agent System: $e');
      }
      // Don't throw - allow app to continue without agents
    }
  }

  /// Check if agent system is initialized
  static bool get isInitialized => _initialized;

  /// Quick start - initialize and run initial analysis
  static Future<void> quickStart({
    String? location,
    String? userId,
  }) async {
    await initialize();

    if (!_initialized) return;

    try {
      // Run initial agent checks
      if (kDebugMode) {
        print('Running initial agent analysis...');
      }

      await AgentService.runAgentsNow();
      await AgentService.checkNotifications();

      if (kDebugMode) {
        print('Initial agent analysis completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in quick start: $e');
      }
    }
  }
}
