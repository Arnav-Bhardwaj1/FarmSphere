import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/agent_models.dart';

/// Database service for agent data persistence
class AgentDatabase {
  static Database? _database;
  static const String _databaseName = 'farmsphere_agents.db';
  static const int _databaseVersion = 1;
  static bool _ffiInitialized = false;
  
  // Web platform doesn't support SQLite
  static bool get _isWebPlatform => kIsWeb;
  
  /// Initialize FFI for desktop platforms
  static void _initializeFfi() {
    if (_ffiInitialized) return;
    if (kIsWeb) return;
    
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      // Set the database factory
      databaseFactory = databaseFactoryFfi;
      _ffiInitialized = true;
      
      if (kDebugMode) {
        print('SQLite FFI initialized for desktop platform');
      }
    }
  }

  // Table names (public for cleanup service)
  static const String tasksTable = 'agent_tasks';
  static const String decisionsTable = 'agent_decisions';
  static const String notificationsTable = 'agent_notifications';
  static const String insightsTable = 'agent_insights';
  static const String settingsTable = 'agent_settings';
  
  // Private aliases for internal use
  static const String _tasksTable = tasksTable;
  static const String _decisionsTable = decisionsTable;
  static const String _notificationsTable = notificationsTable;
  static const String _insightsTable = insightsTable;
  static const String _settingsTable = settingsTable;

  /// Get database instance
  static Future<Database> get database async {
    if (_isWebPlatform) {
      throw UnsupportedError('SQLite database is not supported on web platform');
    }
    
    // Initialize FFI for desktop platforms
    _initializeFfi();
    
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  static Future<Database> _initDatabase() async {
    if (_isWebPlatform) {
      throw UnsupportedError('SQLite database is not supported on web platform');
    }
    
    // Initialize FFI before getting database path
    _initializeFfi();
    
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  static Future<void> _onCreate(Database db, int version) async {
    // Agent tasks table
    await db.execute('''
      CREATE TABLE $_tasksTable (
        id TEXT PRIMARY KEY,
        type INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        context TEXT NOT NULL,
        scheduled_time TEXT NOT NULL,
        priority INTEGER NOT NULL,
        status INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        completed_at TEXT,
        error TEXT
      )
    ''');

    // Agent decisions table
    await db.execute('''
      CREATE TABLE $_decisionsTable (
        id TEXT PRIMARY KEY,
        agent_type INTEGER NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        reasoning TEXT NOT NULL,
        priority INTEGER NOT NULL,
        confidence REAL NOT NULL,
        data TEXT NOT NULL,
        actions TEXT NOT NULL,
        created_at TEXT NOT NULL,
        acknowledged INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Agent notifications table
    await db.execute('''
      CREATE TABLE $_notificationsTable (
        id TEXT PRIMARY KEY,
        agent_type INTEGER NOT NULL,
        category INTEGER NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        priority INTEGER NOT NULL,
        payload TEXT NOT NULL,
        scheduled_time TEXT NOT NULL,
        sent_at TEXT,
        sent INTEGER NOT NULL DEFAULT 0,
        read INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Agent insights table
    await db.execute('''
      CREATE TABLE $_insightsTable (
        id TEXT PRIMARY KEY,
        agent_type INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        action_text TEXT NOT NULL,
        action_data TEXT NOT NULL,
        priority INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        expires_at TEXT,
        dismissed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Agent settings table
    await db.execute('''
      CREATE TABLE $_settingsTable (
        agent_type INTEGER PRIMARY KEY,
        enabled INTEGER NOT NULL DEFAULT 1,
        preferences TEXT NOT NULL,
        last_updated TEXT NOT NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute(
        'CREATE INDEX idx_tasks_status ON $_tasksTable(status, scheduled_time)');
    await db.execute(
        'CREATE INDEX idx_decisions_priority ON $_decisionsTable(priority, created_at)');
    await db.execute(
        'CREATE INDEX idx_notifications_sent ON $_notificationsTable(sent, scheduled_time)');
    await db.execute(
        'CREATE INDEX idx_insights_dismissed ON $_insightsTable(dismissed, expires_at)');
  }

  /// Handle database upgrades
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future schema migrations here
  }

  // ==================== AGENT TASKS ====================

  /// Insert a new agent task
  static Future<void> insertTask(AgentTask task) async {
    final db = await database;
    final map = task.toMap();
    map['context'] = jsonEncode(map['context']);
    await db.insert(_tasksTable, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get all pending tasks
  static Future<List<AgentTask>> getPendingTasks() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> maps = await db.query(
      _tasksTable,
      where: 'status = ? AND scheduled_time <= ?',
      whereArgs: [AgentTaskStatus.pending.index, now],
      orderBy: 'priority DESC, scheduled_time ASC',
    );

    return maps.map((map) {
      final taskMap = Map<String, dynamic>.from(map);
      taskMap['context'] = jsonDecode(map['context'] as String);
      return AgentTask.fromMap(taskMap);
    }).toList();
  }

  /// Get tasks by type
  static Future<List<AgentTask>> getTasksByType(AgentType type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tasksTable,
      where: 'type = ?',
      whereArgs: [type.index],
      orderBy: 'created_at DESC',
      limit: 50,
    );

    return maps.map((map) {
      final taskMap = Map<String, dynamic>.from(map);
      taskMap['context'] = jsonDecode(map['context'] as String);
      return AgentTask.fromMap(taskMap);
    }).toList();
  }

  /// Update task status
  static Future<void> updateTaskStatus(
      String taskId, AgentTaskStatus status, {String? error}) async {
    final db = await database;
    await db.update(
      _tasksTable,
      {
        'status': status.index,
        'completed_at': status == AgentTaskStatus.completed ||
                status == AgentTaskStatus.failed ||
                status == AgentTaskStatus.cancelled
            ? DateTime.now().toIso8601String()
            : null,
        'error': error,
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  /// Delete old completed tasks (keep last 7 days)
  static Future<void> cleanupOldTasks() async {
    final db = await database;
    final cutoffDate =
        DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    await db.delete(
      _tasksTable,
      where: 'status IN (?, ?, ?) AND completed_at < ?',
      whereArgs: [
        AgentTaskStatus.completed.index,
        AgentTaskStatus.failed.index,
        AgentTaskStatus.cancelled.index,
        cutoffDate,
      ],
    );
  }

  // ==================== AGENT DECISIONS ====================

  /// Insert a new agent decision
  static Future<void> insertDecision(AgentDecision decision) async {
    final db = await database;
    final map = decision.toMap();
    map['data'] = jsonEncode(map['data']);
    map['actions'] = jsonEncode(map['actions']);
    await db.insert(_decisionsTable, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get recent decisions
  static Future<List<AgentDecision>> getRecentDecisions({int limit = 20}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _decisionsTable,
      orderBy: 'created_at DESC',
      limit: limit,
    );

    return maps.map((map) {
      final decisionMap = Map<String, dynamic>.from(map);
      decisionMap['data'] = jsonDecode(map['data'] as String);
      decisionMap['actions'] = jsonDecode(map['actions'] as String);
      return AgentDecision.fromMap(decisionMap);
    }).toList();
  }

  /// Get unacknowledged decisions
  static Future<List<AgentDecision>> getUnacknowledgedDecisions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _decisionsTable,
      where: 'acknowledged = ?',
      whereArgs: [0],
      orderBy: 'priority DESC, created_at DESC',
    );

    return maps.map((map) {
      final decisionMap = Map<String, dynamic>.from(map);
      decisionMap['data'] = jsonDecode(map['data'] as String);
      decisionMap['actions'] = jsonDecode(map['actions'] as String);
      return AgentDecision.fromMap(decisionMap);
    }).toList();
  }

  /// Mark decision as acknowledged
  static Future<void> acknowledgeDecision(String decisionId) async {
    final db = await database;
    await db.update(
      _decisionsTable,
      {'acknowledged': 1},
      where: 'id = ?',
      whereArgs: [decisionId],
    );
  }

  /// Delete old decisions (keep last 30 days)
  static Future<void> cleanupOldDecisions() async {
    final db = await database;
    final cutoffDate =
        DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
    await db.delete(
      _decisionsTable,
      where: 'created_at < ?',
      whereArgs: [cutoffDate],
    );
  }

  // ==================== AGENT NOTIFICATIONS ====================

  /// Insert a new notification
  static Future<void> insertNotification(AgentNotification notification) async {
    final db = await database;
    final map = notification.toMap();
    map['payload'] = jsonEncode(map['payload']);
    await db.insert(_notificationsTable, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get pending notifications
  static Future<List<AgentNotification>> getPendingNotifications() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> maps = await db.query(
      _notificationsTable,
      where: 'sent = ? AND scheduled_time <= ?',
      whereArgs: [0, now],
      orderBy: 'priority DESC, scheduled_time ASC',
    );

    return maps.map((map) {
      final notificationMap = Map<String, dynamic>.from(map);
      notificationMap['payload'] = jsonDecode(map['payload'] as String);
      return AgentNotification.fromMap(notificationMap);
    }).toList();
  }

  /// Mark notification as sent
  static Future<void> markNotificationSent(String notificationId) async {
    final db = await database;
    await db.update(
      _notificationsTable,
      {
        'sent': 1,
        'sent_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  /// Mark notification as read
  static Future<void> markNotificationRead(String notificationId) async {
    final db = await database;
    await db.update(
      _notificationsTable,
      {'read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  /// Get notification history
  static Future<List<AgentNotification>> getNotificationHistory({int limit = 50}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _notificationsTable,
      where: 'sent = ?',
      whereArgs: [1],
      orderBy: 'sent_at DESC',
      limit: limit,
    );

    return maps.map((map) {
      final notificationMap = Map<String, dynamic>.from(map);
      notificationMap['payload'] = jsonDecode(map['payload'] as String);
      return AgentNotification.fromMap(notificationMap);
    }).toList();
  }

  /// Delete old notifications (keep last 30 days)
  static Future<void> cleanupOldNotifications() async {
    final db = await database;
    final cutoffDate =
        DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
    await db.delete(
      _notificationsTable,
      where: 'sent = ? AND sent_at < ?',
      whereArgs: [1, cutoffDate],
    );
  }

  // ==================== AGENT INSIGHTS ====================

  /// Insert a new insight
  static Future<void> insertInsight(AgentInsight insight) async {
    final db = await database;
    final map = insight.toMap();
    map['action_data'] = jsonEncode(map['action_data']);
    await db.insert(_insightsTable, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get active insights (not dismissed and not expired)
  static Future<List<AgentInsight>> getActiveInsights() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> maps = await db.query(
      _insightsTable,
      where: 'dismissed = ? AND (expires_at IS NULL OR expires_at > ?)',
      whereArgs: [0, now],
      orderBy: 'priority DESC, created_at DESC',
    );

    return maps.map((map) {
      final insightMap = Map<String, dynamic>.from(map);
      insightMap['action_data'] = jsonDecode(map['action_data'] as String);
      return AgentInsight.fromMap(insightMap);
    }).toList();
  }

  /// Dismiss an insight
  static Future<void> dismissInsight(String insightId) async {
    final db = await database;
    await db.update(
      _insightsTable,
      {'dismissed': 1},
      where: 'id = ?',
      whereArgs: [insightId],
    );
  }

  /// Delete expired insights
  static Future<void> cleanupExpiredInsights() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    await db.delete(
      _insightsTable,
      where: 'expires_at IS NOT NULL AND expires_at < ?',
      whereArgs: [now],
    );
  }

  // ==================== AGENT SETTINGS ====================

  /// Insert or update agent settings
  static Future<void> saveSettings(AgentSettings settings) async {
    final db = await database;
    final map = settings.toMap();
    map['preferences'] = jsonEncode(map['preferences']);
    await db.insert(_settingsTable, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get settings for an agent type
  static Future<AgentSettings?> getSettings(AgentType agentType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _settingsTable,
      where: 'agent_type = ?',
      whereArgs: [agentType.index],
    );

    if (maps.isEmpty) return null;

    final settingsMap = Map<String, dynamic>.from(maps.first);
    settingsMap['preferences'] = jsonDecode(maps.first['preferences'] as String);
    return AgentSettings.fromMap(settingsMap);
  }

  /// Get all agent settings
  static Future<List<AgentSettings>> getAllSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_settingsTable);

    return maps.map((map) {
      final settingsMap = Map<String, dynamic>.from(map);
      settingsMap['preferences'] = jsonDecode(map['preferences'] as String);
      return AgentSettings.fromMap(settingsMap);
    }).toList();
  }

  /// Check if an agent is enabled
  static Future<bool> isAgentEnabled(AgentType agentType) async {
    final settings = await getSettings(agentType);
    return settings?.enabled ?? true; // Default to enabled
  }

  // ==================== DATABASE MAINTENANCE ====================

  /// Run all cleanup operations
  static Future<void> performMaintenance() async {
    await cleanupOldTasks();
    await cleanupOldDecisions();
    await cleanupOldNotifications();
    await cleanupExpiredInsights();
  }

  /// Close database
  static Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
