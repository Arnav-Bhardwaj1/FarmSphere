/// Data models for the autonomous AI agent system
library;

enum AgentType {
  cropHealth,
  weather,
  activity,
  market,
  resource,
}

enum AgentPriority {
  low,
  medium,
  high,
  critical,
}

enum AgentTaskStatus {
  pending,
  running,
  completed,
  failed,
  cancelled,
}

enum NotificationCategory {
  weather,
  cropHealth,
  activity,
  market,
  resource,
  general,
}

/// Represents a scheduled agent task
class AgentTask {
  final String id;
  final AgentType type;
  final String name;
  final String description;
  final Map<String, dynamic> context;
  final DateTime scheduledTime;
  final AgentPriority priority;
  final AgentTaskStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? error;

  AgentTask({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.context,
    required this.scheduledTime,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.error,
  });

  factory AgentTask.fromMap(Map<String, dynamic> map) {
    return AgentTask(
      id: map['id'] as String,
      type: AgentType.values[map['type'] as int],
      name: map['name'] as String,
      description: map['description'] as String,
      context: Map<String, dynamic>.from(map['context'] as Map? ?? {}),
      scheduledTime: DateTime.parse(map['scheduled_time'] as String),
      priority: AgentPriority.values[map['priority'] as int],
      status: AgentTaskStatus.values[map['status'] as int],
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      error: map['error'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'name': name,
      'description': description,
      'context': context,
      'scheduled_time': scheduledTime.toIso8601String(),
      'priority': priority.index,
      'status': status.index,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'error': error,
    };
  }

  AgentTask copyWith({
    String? id,
    AgentType? type,
    String? name,
    String? description,
    Map<String, dynamic>? context,
    DateTime? scheduledTime,
    AgentPriority? priority,
    AgentTaskStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? error,
  }) {
    return AgentTask(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      context: context ?? this.context,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      error: error ?? this.error,
    );
  }
}

/// Represents an AI agent's decision
class AgentDecision {
  final String id;
  final AgentType agentType;
  final String title;
  final String message;
  final String reasoning;
  final AgentPriority priority;
  final double confidence;
  final Map<String, dynamic> data;
  final List<String> actions;
  final DateTime createdAt;
  final bool acknowledged;

  AgentDecision({
    required this.id,
    required this.agentType,
    required this.title,
    required this.message,
    required this.reasoning,
    required this.priority,
    required this.confidence,
    required this.data,
    required this.actions,
    required this.createdAt,
    this.acknowledged = false,
  });

  factory AgentDecision.fromMap(Map<String, dynamic> map) {
    return AgentDecision(
      id: map['id'] as String,
      agentType: AgentType.values[map['agent_type'] as int],
      title: map['title'] as String,
      message: map['message'] as String,
      reasoning: map['reasoning'] as String,
      priority: AgentPriority.values[map['priority'] as int],
      confidence: map['confidence'] as double,
      data: Map<String, dynamic>.from(map['data'] as Map? ?? {}),
      actions: List<String>.from(map['actions'] as List? ?? []),
      createdAt: DateTime.parse(map['created_at'] as String),
      acknowledged: (map['acknowledged'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agent_type': agentType.index,
      'title': title,
      'message': message,
      'reasoning': reasoning,
      'priority': priority.index,
      'confidence': confidence,
      'data': data,
      'actions': actions,
      'created_at': createdAt.toIso8601String(),
      'acknowledged': acknowledged ? 1 : 0,
    };
  }

  AgentDecision copyWith({
    String? id,
    AgentType? agentType,
    String? title,
    String? message,
    String? reasoning,
    AgentPriority? priority,
    double? confidence,
    Map<String, dynamic>? data,
    List<String>? actions,
    DateTime? createdAt,
    bool? acknowledged,
  }) {
    return AgentDecision(
      id: id ?? this.id,
      agentType: agentType ?? this.agentType,
      title: title ?? this.title,
      message: message ?? this.message,
      reasoning: reasoning ?? this.reasoning,
      priority: priority ?? this.priority,
      confidence: confidence ?? this.confidence,
      data: data ?? this.data,
      actions: actions ?? this.actions,
      createdAt: createdAt ?? this.createdAt,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }
}

/// Represents an agent notification
class AgentNotification {
  final String id;
  final AgentType agentType;
  final NotificationCategory category;
  final String title;
  final String body;
  final AgentPriority priority;
  final Map<String, dynamic> payload;
  final DateTime scheduledTime;
  final DateTime? sentAt;
  final bool sent;
  final bool read;

  AgentNotification({
    required this.id,
    required this.agentType,
    required this.category,
    required this.title,
    required this.body,
    required this.priority,
    required this.payload,
    required this.scheduledTime,
    this.sentAt,
    this.sent = false,
    this.read = false,
  });

  factory AgentNotification.fromMap(Map<String, dynamic> map) {
    return AgentNotification(
      id: map['id'] as String,
      agentType: AgentType.values[map['agent_type'] as int],
      category: NotificationCategory.values[map['category'] as int],
      title: map['title'] as String,
      body: map['body'] as String,
      priority: AgentPriority.values[map['priority'] as int],
      payload: Map<String, dynamic>.from(map['payload'] as Map? ?? {}),
      scheduledTime: DateTime.parse(map['scheduled_time'] as String),
      sentAt:
          map['sent_at'] != null ? DateTime.parse(map['sent_at'] as String) : null,
      sent: (map['sent'] as int) == 1,
      read: (map['read'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agent_type': agentType.index,
      'category': category.index,
      'title': title,
      'body': body,
      'priority': priority.index,
      'payload': payload,
      'scheduled_time': scheduledTime.toIso8601String(),
      'sent_at': sentAt?.toIso8601String(),
      'sent': sent ? 1 : 0,
      'read': read ? 1 : 0,
    };
  }

  AgentNotification copyWith({
    String? id,
    AgentType? agentType,
    NotificationCategory? category,
    String? title,
    String? body,
    AgentPriority? priority,
    Map<String, dynamic>? payload,
    DateTime? scheduledTime,
    DateTime? sentAt,
    bool? sent,
    bool? read,
  }) {
    return AgentNotification(
      id: id ?? this.id,
      agentType: agentType ?? this.agentType,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      priority: priority ?? this.priority,
      payload: payload ?? this.payload,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      sentAt: sentAt ?? this.sentAt,
      sent: sent ?? this.sent,
      read: read ?? this.read,
    );
  }
}

/// Agent insight for displaying on UI
class AgentInsight {
  final String id;
  final AgentType agentType;
  final String title;
  final String description;
  final String actionText;
  final Map<String, dynamic> actionData;
  final AgentPriority priority;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool dismissed;

  AgentInsight({
    required this.id,
    required this.agentType,
    required this.title,
    required this.description,
    required this.actionText,
    required this.actionData,
    required this.priority,
    required this.createdAt,
    this.expiresAt,
    this.dismissed = false,
  });

  factory AgentInsight.fromMap(Map<String, dynamic> map) {
    return AgentInsight(
      id: map['id'] as String,
      agentType: AgentType.values[map['agent_type'] as int],
      title: map['title'] as String,
      description: map['description'] as String,
      actionText: map['action_text'] as String,
      actionData: Map<String, dynamic>.from(map['action_data'] as Map? ?? {}),
      priority: AgentPriority.values[map['priority'] as int],
      createdAt: DateTime.parse(map['created_at'] as String),
      expiresAt:
          map['expires_at'] != null ? DateTime.parse(map['expires_at'] as String) : null,
      dismissed: (map['dismissed'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agent_type': agentType.index,
      'title': title,
      'description': description,
      'action_text': actionText,
      'action_data': actionData,
      'priority': priority.index,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'dismissed': dismissed ? 1 : 0,
    };
  }

  AgentInsight copyWith({
    String? id,
    AgentType? agentType,
    String? title,
    String? description,
    String? actionText,
    Map<String, dynamic>? actionData,
    AgentPriority? priority,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? dismissed,
  }) {
    return AgentInsight(
      id: id ?? this.id,
      agentType: agentType ?? this.agentType,
      title: title ?? this.title,
      description: description ?? this.description,
      actionText: actionText ?? this.actionText,
      actionData: actionData ?? this.actionData,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      dismissed: dismissed ?? this.dismissed,
    );
  }
}

/// Agent settings per user
class AgentSettings {
  final AgentType agentType;
  final bool enabled;
  final Map<String, dynamic> preferences;
  final DateTime lastUpdated;

  AgentSettings({
    required this.agentType,
    required this.enabled,
    required this.preferences,
    required this.lastUpdated,
  });

  factory AgentSettings.fromMap(Map<String, dynamic> map) {
    return AgentSettings(
      agentType: AgentType.values[map['agent_type'] as int],
      enabled: (map['enabled'] as int) == 1,
      preferences: Map<String, dynamic>.from(map['preferences'] as Map? ?? {}),
      lastUpdated: DateTime.parse(map['last_updated'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'agent_type': agentType.index,
      'enabled': enabled ? 1 : 0,
      'preferences': preferences,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  AgentSettings copyWith({
    AgentType? agentType,
    bool? enabled,
    Map<String, dynamic>? preferences,
    DateTime? lastUpdated,
  }) {
    return AgentSettings(
      agentType: agentType ?? this.agentType,
      enabled: enabled ?? this.enabled,
      preferences: preferences ?? this.preferences,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
