import 'package:uuid/uuid.dart';
import '../models/agent_models.dart';
import 'agent_database.dart';

/// Service to generate mock data for testing AI agents
class AgentMockData {
  static const _uuid = Uuid();

  /// Initialize mock data for all agents
  static Future<void> initializeMockData() async {
    await _createMockDecisions();
    await _createMockInsights();
    await _createMockTasks();
  }

  /// Create mock agent decisions
  static Future<void> _createMockDecisions() async {
    final mockDecisions = [
      // Weather Agent - Critical
      AgentDecision(
        id: _uuid.v4(),
        agentType: AgentType.weather,
        title: 'Heavy Rain Alert - Take Action',
        message: 'Heavy rainfall predicted in next 48 hours. Protect crops from waterlogging.',
        reasoning: 'Weather forecast shows 85mm rainfall expected. Your field has poor drainage in sectors A and B.',
        priority: AgentPriority.critical,
        confidence: 0.92,
        data: {
          'rainfall_mm': 85,
          'start_time': DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
          'duration_hours': 36,
        },
        actions: [
          'Check drainage systems',
          'Harvest mature crops',
          'Cover sensitive plants',
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),

      // Crop Health Agent - High
      AgentDecision(
        id: _uuid.v4(),
        agentType: AgentType.cropHealth,
        title: 'Early Blight Detected in Tomatoes',
        message: 'Fungal disease pattern detected. Early intervention recommended.',
        reasoning: 'Image analysis shows leaf spotting consistent with early blight. Weather conditions favor spread.',
        priority: AgentPriority.high,
        confidence: 0.87,
        data: {
          'disease': 'Early Blight',
          'affected_area': 'Section C - 15% of plants',
          'confidence_score': 0.87,
        },
        actions: [
          'Apply copper fungicide',
          'Remove infected leaves',
          'Improve air circulation',
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),

      // Market Agent - Medium
      AgentDecision(
        id: _uuid.v4(),
        agentType: AgentType.market,
        title: 'Wheat Prices Up 15% - Good Time to Sell',
        message: 'Market analysis shows optimal selling window for wheat harvest.',
        reasoning: 'Wheat prices increased 15% due to supply shortage. Historical data suggests prices may drop next week.',
        priority: AgentPriority.medium,
        confidence: 0.78,
        data: {
          'crop': 'Wheat',
          'current_price': 2850,
          'price_change': '+15%',
          'recommendation': 'Sell within 3 days',
        },
        actions: [
          'Contact buyers',
          'Prepare for harvest',
          'Check quality standards',
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        acknowledged: false,
      ),

      // Activity Agent - Medium
      AgentDecision(
        id: _uuid.v4(),
        agentType: AgentType.activity,
        title: 'Optimal Time for Fertilization',
        message: 'Based on crop growth stage and weather, next 3 days ideal for fertilizing.',
        reasoning: 'Corn is at V6 stage requiring nitrogen. No rain for 48h ensures good uptake.',
        priority: AgentPriority.medium,
        confidence: 0.85,
        data: {
          'activity': 'Fertilization',
          'crop': 'Corn',
          'window': 'Next 72 hours',
          'nutrient': 'Nitrogen',
        },
        actions: [
          'Apply nitrogen fertilizer',
          'Use split application',
          'Avoid irrigation for 24h',
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        acknowledged: true,
      ),

      // Resource Agent - High
      AgentDecision(
        id: _uuid.v4(),
        agentType: AgentType.resource,
        title: 'Water Usage Alert - 30% Above Optimal',
        message: 'Current irrigation schedule is inefficient. Optimization can save 30% water.',
        reasoning: 'Soil moisture sensors show saturation. Weather forecast includes rain. Reduce irrigation.',
        priority: AgentPriority.high,
        confidence: 0.91,
        data: {
          'current_usage': '1200 L/day',
          'optimal_usage': '840 L/day',
          'potential_savings': '360 L/day',
        },
        actions: [
          'Reduce irrigation by 30%',
          'Check for leaks',
          'Update schedule after rain',
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];

    for (final decision in mockDecisions) {
      await AgentDatabase.insertDecision(decision);
    }
  }

  /// Create mock agent insights
  static Future<void> _createMockInsights() async {
    final mockInsights = [
      AgentInsight(
        id: _uuid.v4(),
        agentType: AgentType.weather,
        title: 'Perfect Planting Window Next Week',
        description: 'Weather forecast shows ideal conditions: 22-26°C, 60% humidity, no rain for 5 days. Excellent for sowing winter wheat.',
        actionText: 'Plan Planting',
        actionData: {
          'start_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
          'crop_recommended': 'Winter Wheat',
          'conditions': 'Optimal',
        },
        priority: AgentPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ),

      AgentInsight(
        id: _uuid.v4(),
        agentType: AgentType.market,
        title: 'Onion Demand Expected to Rise',
        description: 'Market analysis predicts 20% price increase for onions in next 2 months due to festival season. Consider planting if field is available.',
        actionText: 'View Market Trends',
        actionData: {
          'crop': 'Onion',
          'predicted_increase': '20%',
          'timeframe': '2 months',
        },
        priority: AgentPriority.low,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        expiresAt: DateTime.now().add(const Duration(days: 14)),
      ),

      AgentInsight(
        id: _uuid.v4(),
        agentType: AgentType.activity,
        title: 'Pest Control Due This Week',
        description: 'Based on historical data, aphid population typically peaks during this period. Preventive spraying recommended.',
        actionText: 'Schedule Pest Control',
        actionData: {
          'pest': 'Aphids',
          'risk_level': 'Medium',
          'recommendation': 'Preventive spray',
        },
        priority: AgentPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        expiresAt: DateTime.now().add(const Duration(days: 5)),
      ),
    ];

    for (final insight in mockInsights) {
      await AgentDatabase.insertInsight(insight);
    }
  }

  /// Create mock agent tasks
  static Future<void> _createMockTasks() async {
    final now = DateTime.now();

    final mockTasks = [
      AgentTask(
        id: _uuid.v4(),
        type: AgentType.weather,
        name: 'Daily Weather Analysis',
        description: 'Analyze weather forecast for next 7 days and generate alerts',
        context: {
          'location': 'User Farm',
          'forecast_days': 7,
        },
        scheduledTime: now.add(const Duration(hours: 2)),
        priority: AgentPriority.high,
        status: AgentTaskStatus.pending,
        createdAt: now,
      ),

      AgentTask(
        id: _uuid.v4(),
        type: AgentType.cropHealth,
        name: 'Crop Disease Pattern Analysis',
        description: 'Analyze recent crop scans for disease patterns',
        context: {
          'crops': ['Tomato', 'Wheat', 'Corn'],
          'lookback_days': 30,
        },
        scheduledTime: now.add(const Duration(hours: 6)),
        priority: AgentPriority.medium,
        status: AgentTaskStatus.pending,
        createdAt: now,
      ),

      AgentTask(
        id: _uuid.v4(),
        type: AgentType.market,
        name: 'Price Trend Analysis',
        description: 'Monitor market prices and identify selling opportunities',
        context: {
          'crops': ['Wheat', 'Rice', 'Onion'],
          'threshold': 10, // 10% price change
        },
        scheduledTime: now.add(const Duration(hours: 4)),
        priority: AgentPriority.medium,
        status: AgentTaskStatus.completed,
        createdAt: now.subtract(const Duration(hours: 8)),
        completedAt: now.subtract(const Duration(hours: 4)),
      ),
    ];

    for (final task in mockTasks) {
      await AgentDatabase.insertTask(task);
    }
  }
}
