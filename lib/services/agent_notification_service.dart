import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../models/agent_models.dart';
import 'agent_database.dart';
import 'dart:convert';

/// Service for managing agent notifications
class AgentNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;

    if (kDebugMode) {
      print('AgentNotificationService initialized');
    }
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    if (kIsWeb) return true;

    bool? granted;

    if (defaultTargetPlatform == TargetPlatform.android) {
      granted = await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      granted = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    return granted ?? true;
  }

  /// Schedule a notification
  static Future<void> scheduleNotification(AgentNotification notification) async {
    if (!_initialized) {
      await initialize();
    }

    // Store in database first
    await AgentDatabase.insertNotification(notification);

    // Check if it should be sent immediately
    if (notification.scheduledTime.isBefore(DateTime.now()) ||
        notification.scheduledTime.difference(DateTime.now()).inSeconds < 10) {
      await _sendNotification(notification);
    }
  }

  /// Send pending notifications
  static Future<void> sendPendingNotifications() async {
    if (!_initialized) {
      await initialize();
    }

    final pendingNotifications = await AgentDatabase.getPendingNotifications();

    for (final notification in pendingNotifications) {
      await _sendNotification(notification);
    }
  }

  /// Send a notification immediately
  static Future<void> _sendNotification(AgentNotification notification) async {
    try {
      final androidDetails = _getAndroidNotificationDetails(notification);
      final iosDetails = _getIOSNotificationDetails(notification);

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Generate a unique notification ID from the notification ID string
      final notificationId = notification.id.hashCode;

      await _notifications.show(
        notificationId,
        notification.title,
        notification.body,
        details,
        payload: jsonEncode(notification.payload),
      );

      // Mark as sent in database
      await AgentDatabase.markNotificationSent(notification.id);

      if (kDebugMode) {
        print('Notification sent: ${notification.title}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification: $e');
      }
    }
  }

  /// Get Android notification details based on priority and category
  static AndroidNotificationDetails _getAndroidNotificationDetails(
      AgentNotification notification) {
    // Determine channel based on category
    String channelId;
    String channelName;
    String channelDescription;
    Importance importance;
    Priority priority;

    switch (notification.category) {
      case NotificationCategory.weather:
        channelId = 'agent_weather';
        channelName = 'Weather Alerts';
        channelDescription = 'Weather intelligence and alerts from AI agent';
        importance = notification.priority == AgentPriority.critical
            ? Importance.max
            : Importance.high;
        priority = Priority.high;
        break;

      case NotificationCategory.cropHealth:
        channelId = 'agent_crop_health';
        channelName = 'Crop Health';
        channelDescription = 'Crop health monitoring and alerts';
        importance = notification.priority == AgentPriority.critical
            ? Importance.max
            : Importance.high;
        priority = Priority.high;
        break;

      case NotificationCategory.activity:
        channelId = 'agent_activity';
        channelName = 'Activity Reminders';
        channelDescription = 'Farming activity schedules and reminders';
        importance = Importance.defaultImportance;
        priority = Priority.defaultPriority;
        break;

      case NotificationCategory.market:
        channelId = 'agent_market';
        channelName = 'Market Intelligence';
        channelDescription = 'Market prices and selling opportunities';
        importance = Importance.defaultImportance;
        priority = Priority.defaultPriority;
        break;

      case NotificationCategory.resource:
        channelId = 'agent_resource';
        channelName = 'Resource Optimization';
        channelDescription = 'Resource usage and optimization tips';
        importance = Importance.low;
        priority = Priority.low;
        break;

      default:
        channelId = 'agent_general';
        channelName = 'General Notifications';
        channelDescription = 'General agent notifications';
        importance = Importance.defaultImportance;
        priority = Priority.defaultPriority;
    }

    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      playSound: true,
      enableVibration: notification.priority == AgentPriority.critical ||
          notification.priority == AgentPriority.high,
      enableLights: true,
      icon: '@mipmap/ic_launcher',
      styleInformation: notification.body.length > 100
          ? BigTextStyleInformation(
              notification.body,
              contentTitle: notification.title,
            )
          : null,
    );
  }

  /// Get iOS notification details
  static DarwinNotificationDetails _getIOSNotificationDetails(
      AgentNotification notification) {
    return DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: notification.priority == AgentPriority.critical
          ? 'alarm.aiff'
          : 'default',
      interruptionLevel: notification.priority == AgentPriority.critical
          ? InterruptionLevel.critical
          : notification.priority == AgentPriority.high
              ? InterruptionLevel.timeSensitive
              : InterruptionLevel.active,
    );
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final payload = jsonDecode(response.payload!);
        // Handle notification tap based on payload
        // This would navigate to relevant screen
        if (kDebugMode) {
          print('Notification tapped: $payload');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing notification payload: $e');
        }
      }
    }
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(String notificationId) async {
    final id = notificationId.hashCode;
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get notification counts by category
  static Future<Map<NotificationCategory, int>> getNotificationCounts() async {
    final history = await AgentDatabase.getNotificationHistory(limit: 100);
    final counts = <NotificationCategory, int>{};

    for (final category in NotificationCategory.values) {
      counts[category] = history.where((n) => n.category == category).length;
    }

    return counts;
  }

  /// Send a test notification
  static Future<void> sendTestNotification() async {
    if (!_initialized) {
      await initialize();
    }

    final testNotification = AgentNotification(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      agentType: AgentType.weather,
      category: NotificationCategory.general,
      title: 'FarmSphere AI Agent',
      body: 'Test notification - Your AI agents are working!',
      priority: AgentPriority.medium,
      payload: {'test': true},
      scheduledTime: DateTime.now(),
    );

    await _sendNotification(testNotification);
  }

  /// Create notification for agent decision
  static Future<void> notifyDecision(AgentDecision decision) async {
    final notification = AgentNotification(
      id: 'decision_${decision.id}',
      agentType: decision.agentType,
      category: _getCategoryForAgentType(decision.agentType),
      title: decision.title,
      body: decision.message,
      priority: decision.priority,
      payload: {
        'type': 'decision',
        'decisionId': decision.id,
        'agentType': decision.agentType.name,
        ...decision.data,
      },
      scheduledTime: DateTime.now(),
    );

    await scheduleNotification(notification);
  }

  /// Create notification for agent insight
  static Future<void> notifyInsight(AgentInsight insight) async {
    final notification = AgentNotification(
      id: 'insight_${insight.id}',
      agentType: insight.agentType,
      category: _getCategoryForAgentType(insight.agentType),
      title: insight.title,
      body: insight.description,
      priority: insight.priority,
      payload: {
        'type': 'insight',
        'insightId': insight.id,
        'agentType': insight.agentType.name,
        ...insight.actionData,
      },
      scheduledTime: DateTime.now(),
    );

    await scheduleNotification(notification);
  }

  /// Get notification category for agent type
  static NotificationCategory _getCategoryForAgentType(AgentType agentType) {
    switch (agentType) {
      case AgentType.weather:
        return NotificationCategory.weather;
      case AgentType.cropHealth:
        return NotificationCategory.cropHealth;
      case AgentType.activity:
        return NotificationCategory.activity;
      case AgentType.market:
        return NotificationCategory.market;
      case AgentType.resource:
        return NotificationCategory.resource;
    }
  }

  /// Schedule recurring check for pending notifications
  /// This should be called periodically by background task service
  static Future<void> checkAndSendPending() async {
    try {
      await sendPendingNotifications();
    } catch (e) {
      if (kDebugMode) {
        print('Error in checkAndSendPending: $e');
      }
    }
  }
}
