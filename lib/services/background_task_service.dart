import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../models/agent_models.dart';
import 'agent_database.dart';
import 'agent_notification_service.dart';

/// Service for managing background tasks
class BackgroundTaskService {
  static const String _agentTaskName = 'farmsphere_agent_task';
  static const String _maintenanceTaskName = 'farmsphere_maintenance_task';
  static const String _notificationTaskName = 'farmsphere_notification_task';

  static bool _initialized = false;

  /// Initialize background task service
  static Future<void> initialize() async {
    if (_initialized) return;

    if (!kIsWeb) {
      try {
        await Workmanager().initialize(
          _callbackDispatcher,
          isInDebugMode: kDebugMode,
        );
        _initialized = true;

        if (kDebugMode) {
          print('BackgroundTaskService initialized');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing WorkManager: $e');
        }
      }
    }
  }

  /// Register periodic agent execution
  static Future<void> registerAgentTasks() async {
    if (!_initialized) {
      await initialize();
    }

    if (kIsWeb) return;

    try {
      // Register periodic task to run agents every 30 minutes
      await Workmanager().registerPeriodicTask(
        'agent_periodic',
        _agentTaskName,
        frequency: const Duration(minutes: 30),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        inputData: {
          'task_type': 'agent_execution',
        },
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );

      // Register periodic task to send pending notifications every 15 minutes
      await Workmanager().registerPeriodicTask(
        'notification_periodic',
        _notificationTaskName,
        frequency: const Duration(minutes: 15),
        inputData: {
          'task_type': 'notification_check',
        },
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );

      // Register daily maintenance task
      await Workmanager().registerPeriodicTask(
        'maintenance_periodic',
        _maintenanceTaskName,
        frequency: const Duration(hours: 24),
        inputData: {
          'task_type': 'maintenance',
        },
        existingWorkPolicy: ExistingWorkPolicy.keep,
      );

      if (kDebugMode) {
        print('Background tasks registered');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error registering background tasks: $e');
      }
    }
  }

  /// Cancel all background tasks
  static Future<void> cancelAllTasks() async {
    if (kIsWeb) return;

    try {
      await Workmanager().cancelAll();
      if (kDebugMode) {
        print('All background tasks cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling tasks: $e');
      }
    }
  }

  /// Schedule a one-time task
  static Future<void> scheduleOneTimeTask({
    required String uniqueName,
    required String taskName,
    required Duration delay,
    Map<String, dynamic>? inputData,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    if (kIsWeb) return;

    try {
      await Workmanager().registerOneOffTask(
        uniqueName,
        taskName,
        initialDelay: delay,
        inputData: inputData,
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );

      if (kDebugMode) {
        print('One-time task scheduled: $uniqueName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scheduling one-time task: $e');
      }
    }
  }

  /// Execute agent tasks immediately (for testing)
  static Future<void> executeAgentTasksNow() async {
    try {
      await _runAgentTasks();
    } catch (e) {
      if (kDebugMode) {
        print('Error executing agent tasks: $e');
      }
    }
  }

  /// Execute notification check immediately
  static Future<void> checkNotificationsNow() async {
    try {
      await AgentNotificationService.checkAndSendPending();
    } catch (e) {
      if (kDebugMode) {
        print('Error checking notifications: $e');
      }
    }
  }

  /// Run agent tasks
  static Future<void> _runAgentTasks() async {
    if (kDebugMode) {
      print('Running agent tasks...');
    }

    try {
      // Get pending tasks from database
      final pendingTasks = await AgentDatabase.getPendingTasks();

      if (kDebugMode) {
        print('Found ${pendingTasks.length} pending tasks');
      }

      for (final task in pendingTasks) {
        try {
          // Check if agent is enabled
          final isEnabled = await AgentDatabase.isAgentEnabled(task.type);
          if (!isEnabled) {
            await AgentDatabase.updateTaskStatus(
              task.id,
              AgentTaskStatus.cancelled,
              error: 'Agent disabled',
            );
            continue;
          }

          // Update task status to running
          await AgentDatabase.updateTaskStatus(task.id, AgentTaskStatus.running);

          // Execute the agent task based on type
          // This will be handled by the specific agent implementations
          // For now, just mark as completed
          await AgentDatabase.updateTaskStatus(task.id, AgentTaskStatus.completed);

          if (kDebugMode) {
            print('Completed task: ${task.name}');
          }
        } catch (e) {
          await AgentDatabase.updateTaskStatus(
            task.id,
            AgentTaskStatus.failed,
            error: e.toString(),
          );
          if (kDebugMode) {
            print('Task failed: ${task.name} - $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error running agent tasks: $e');
      }
    }
  }

  /// Run maintenance tasks
  static Future<void> _runMaintenance() async {
    if (kDebugMode) {
      print('Running maintenance...');
    }

    try {
      await AgentDatabase.performMaintenance();
      if (kDebugMode) {
        print('Maintenance completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error running maintenance: $e');
      }
    }
  }
}

/// Callback dispatcher for background tasks
/// This runs in an isolate, so it needs to be a top-level function
@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      if (kDebugMode) {
        print('Background task started: $taskName');
      }

      switch (taskName) {
        case BackgroundTaskService._agentTaskName:
          await BackgroundTaskService._runAgentTasks();
          break;

        case BackgroundTaskService._notificationTaskName:
          await AgentNotificationService.initialize();
          await AgentNotificationService.checkAndSendPending();
          break;

        case BackgroundTaskService._maintenanceTaskName:
          await BackgroundTaskService._runMaintenance();
          break;

        default:
          if (kDebugMode) {
            print('Unknown task: $taskName');
          }
      }

      if (kDebugMode) {
        print('Background task completed: $taskName');
      }

      return Future.value(true);
    } catch (e) {
      if (kDebugMode) {
        print('Error in background task $taskName: $e');
      }
      return Future.value(false);
    }
  });
}
