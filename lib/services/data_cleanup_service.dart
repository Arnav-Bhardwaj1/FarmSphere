import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'agent_database.dart';

/// Service for managing data cleanup and retention policies
class DataCleanupService {
  // Retention periods (in days)
  static const int notificationRetentionDays = 30;
  static const int insightRetentionDays = 90;
  static const int completedTaskRetentionDays = 60;
  static const int decisionRetentionDays = 180;
  static const int expiredInsightRetentionDays = 7; // Keep expired insights for 7 days

  /// Initialize cleanup service and schedule periodic cleanup
  static Future<void> initialize() async {
    if (kDebugMode) {
      print('DataCleanupService: Initializing');
    }

    // Run initial cleanup
    await cleanupOldData();

    // Store last cleanup time
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_cleanup_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  /// Check if cleanup is needed (run daily)
  static Future<bool> shouldRunCleanup() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCleanup = prefs.getInt('last_cleanup_timestamp') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final daysSinceCleanup = (now - lastCleanup) / (1000 * 60 * 60 * 24);
    
    return daysSinceCleanup >= 1.0;
  }

  /// Run comprehensive data cleanup
  static Future<void> cleanupOldData() async {
    if (kDebugMode) {
      print('DataCleanupService: Starting cleanup');
    }

    // Skip cleanup on web platform (no database support)
    if (kIsWeb) {
      if (kDebugMode) {
        print('DataCleanupService: Skipping cleanup on web platform');
      }
      return;
    }

    try {
      final results = await Future.wait([
        _cleanupOldNotifications(),
        _cleanupExpiredInsights(),
        _cleanupCompletedTasks(),
        _cleanupOldDecisions(),
      ]);

      final totalDeleted = results.reduce((a, b) => a + b);

      if (kDebugMode) {
        print('DataCleanupService: Cleanup complete. Deleted $totalDeleted records');
      }

      // Update last cleanup time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_cleanup_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error during cleanup - $e');
      }
    }
  }

  /// Clean up old notifications
  static Future<int> _cleanupOldNotifications() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: notificationRetentionDays));
      final db = await AgentDatabase.database;

      final result = await db.delete(
        AgentDatabase.notificationsTable,
        where: 'created_at < ?',
        whereArgs: [cutoffDate.toIso8601String()],
      );

      if (kDebugMode && result > 0) {
        print('DataCleanupService: Deleted $result old notifications');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error cleaning notifications - $e');
      }
      return 0;
    }
  }

  /// Clean up expired insights
  static Future<int> _cleanupExpiredInsights() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: expiredInsightRetentionDays));
      final db = await AgentDatabase.database;

      // Delete insights that expired more than 7 days ago
      final result = await db.delete(
        AgentDatabase.insightsTable,
        where: 'expires_at < ? AND expires_at IS NOT NULL',
        whereArgs: [cutoffDate.toIso8601String()],
      );

      if (kDebugMode && result > 0) {
        print('DataCleanupService: Deleted $result expired insights');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error cleaning insights - $e');
      }
      return 0;
    }
  }

  /// Clean up old completed tasks
  static Future<int> _cleanupCompletedTasks() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: completedTaskRetentionDays));
      final db = await AgentDatabase.database;

      // Delete completed or failed tasks older than retention period
      final result = await db.delete(
        AgentDatabase.tasksTable,
        where: '(status = ? OR status = ?) AND completed_at < ?',
        whereArgs: [2, 3, cutoffDate.toIso8601String()], // 2=completed, 3=failed
      );

      if (kDebugMode && result > 0) {
        print('DataCleanupService: Deleted $result old completed tasks');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error cleaning tasks - $e');
      }
      return 0;
    }
  }

  /// Clean up old acknowledged decisions
  static Future<int> _cleanupOldDecisions() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: decisionRetentionDays));
      final db = await AgentDatabase.database;

      // Delete acknowledged decisions older than retention period
      final result = await db.delete(
        AgentDatabase.decisionsTable,
        where: 'acknowledged = ? AND created_at < ?',
        whereArgs: [1, cutoffDate.toIso8601String()],
      );

      if (kDebugMode && result > 0) {
        print('DataCleanupService: Deleted $result old decisions');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error cleaning decisions - $e');
      }
      return 0;
    }
  }

  /// Get storage statistics
  static Future<Map<String, int>> getStorageStats() async {
    try {
      final db = await AgentDatabase.database;

      final tasks = await db.query(AgentDatabase.tasksTable);
      final decisions = await db.query(AgentDatabase.decisionsTable);
      final notifications = await db.query(AgentDatabase.notificationsTable);
      final insights = await db.query(AgentDatabase.insightsTable);

      return {
        'tasks': tasks.length,
        'decisions': decisions.length,
        'notifications': notifications.length,
        'insights': insights.length,
        'total': tasks.length + decisions.length + notifications.length + insights.length,
      };
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error getting storage stats - $e');
      }
      return {};
    }
  }

  /// Clear all agent data (for complete reset)
  static Future<void> clearAllData() async {
    if (kDebugMode) {
      print('DataCleanupService: Clearing all agent data');
    }

    try {
      final db = await AgentDatabase.database;

      await Future.wait([
        db.delete(AgentDatabase.tasksTable),
        db.delete(AgentDatabase.decisionsTable),
        db.delete(AgentDatabase.notificationsTable),
        db.delete(AgentDatabase.insightsTable),
      ]);

      if (kDebugMode) {
        print('DataCleanupService: All data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error clearing data - $e');
      }
      rethrow;
    }
  }

  /// Clear data for specific agent
  static Future<void> clearAgentData(int agentType) async {
    if (kDebugMode) {
      print('DataCleanupService: Clearing data for agent $agentType');
    }

    try {
      final db = await AgentDatabase.database;

      await Future.wait([
        db.delete(
          AgentDatabase.tasksTable,
          where: 'type = ?',
          whereArgs: [agentType],
        ),
        db.delete(
          AgentDatabase.decisionsTable,
          where: 'agent_type = ?',
          whereArgs: [agentType],
        ),
        db.delete(
          AgentDatabase.insightsTable,
          where: 'agent_type = ?',
          whereArgs: [agentType],
        ),
      ]);

      if (kDebugMode) {
        print('DataCleanupService: Agent $agentType data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error clearing agent data - $e');
      }
      rethrow;
    }
  }

  /// Export data for backup (returns JSON-serializable map)
  static Future<Map<String, dynamic>> exportData() async {
    if (kDebugMode) {
      print('DataCleanupService: Exporting data');
    }

    try {
      final db = await AgentDatabase.database;

      final tasks = await db.query(AgentDatabase.tasksTable);
      final decisions = await db.query(AgentDatabase.decisionsTable);
      final notifications = await db.query(AgentDatabase.notificationsTable);
      final insights = await db.query(AgentDatabase.insightsTable);

      return {
        'version': '1.0',
        'exported_at': DateTime.now().toIso8601String(),
        'data': {
          'tasks': tasks,
          'decisions': decisions,
          'notifications': notifications,
          'insights': insights,
        },
      };
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error exporting data - $e');
      }
      rethrow;
    }
  }

  /// Get data age statistics
  static Future<Map<String, String>> getDataAgeStats() async {
    try {
      final db = await AgentDatabase.database;

      // Get oldest and newest records for each type
      final stats = <String, String>{};

      // Tasks
      final oldestTask = await db.query(
        AgentDatabase.tasksTable,
        orderBy: 'created_at ASC',
        limit: 1,
      );
      if (oldestTask.isNotEmpty) {
        final date = DateTime.parse(oldestTask.first['created_at'] as String);
        stats['oldest_task'] = _formatAge(date);
      }

      // Decisions
      final oldestDecision = await db.query(
        AgentDatabase.decisionsTable,
        orderBy: 'created_at ASC',
        limit: 1,
      );
      if (oldestDecision.isNotEmpty) {
        final date = DateTime.parse(oldestDecision.first['created_at'] as String);
        stats['oldest_decision'] = _formatAge(date);
      }

      // Notifications
      final oldestNotification = await db.query(
        AgentDatabase.notificationsTable,
        orderBy: 'created_at ASC',
        limit: 1,
      );
      if (oldestNotification.isNotEmpty) {
        final date = DateTime.parse(oldestNotification.first['created_at'] as String);
        stats['oldest_notification'] = _formatAge(date);
      }

      return stats;
    } catch (e) {
      if (kDebugMode) {
        print('DataCleanupService: Error getting age stats - $e');
      }
      return {};
    }
  }

  static String _formatAge(DateTime date) {
    final age = DateTime.now().difference(date).inDays;
    if (age < 1) return 'Today';
    if (age == 1) return '1 day ago';
    if (age < 30) return '$age days ago';
    if (age < 60) return '1 month ago';
    if (age < 365) return '${(age / 30).floor()} months ago';
    return '${(age / 365).floor()} years ago';
  }
}
