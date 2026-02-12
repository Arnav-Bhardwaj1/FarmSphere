import 'package:flutter/foundation.dart';
import '../models/agent_models.dart';
import '../services/weather_service.dart';
import '../services/agent_service.dart';
import '../services/agent_database.dart';

/// Weather Intelligence Agent - Analyzes weather and generates actionable alerts
class WeatherAgent {
  static const AgentType agentType = AgentType.weather;

  /// Analyze weather and generate decisions
  static Future<void> analyze(String location, {String? userId}) async {
    if (kDebugMode) {
      print('WeatherAgent: Starting analysis for $location');
    }

    try {
      // Check if agent is enabled
      final isEnabled = await AgentDatabase.isAgentEnabled(agentType);
      if (!isEnabled) {
        if (kDebugMode) {
          print('WeatherAgent: Agent is disabled');
        }
        return;
      }

      // Fetch weather data
      final currentWeather = await WeatherService.getCurrentWeather(location);
      final forecast = await WeatherService.getWeatherForecast(location);
      final alerts = await WeatherService.getWeatherAlerts(location);

      // Analyze current conditions
      await _analyzeCurrentConditions(currentWeather, location);

      // Analyze forecast
      await _analyzeForecast(forecast, location);

      // Analyze weather alerts
      await _analyzeAlerts(alerts, location);

      // Generate insights
      await _generateInsights(currentWeather, forecast, location);

      if (kDebugMode) {
        print('WeatherAgent: Analysis completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('WeatherAgent: Error during analysis - $e');
      }
    }
  }

  /// Analyze current weather conditions
  static Future<void> _analyzeCurrentConditions(
    Map<String, dynamic> weather,
    String location,
  ) async {
    final temp = weather['temperature'] as int? ?? 0;
    final humidity = weather['humidity'] as int? ?? 0;
    final windSpeed = weather['windSpeed'] as double? ?? 0;
    final condition = weather['condition'] as String? ?? '';

    // Check for extreme conditions
    if (temp > 40) {
      await _createHeatWaveDecision(temp, location);
    } else if (temp < 5) {
      await _createFrostWarningDecision(temp, location);
    }

    if (humidity > 85) {
      await _createHighHumidityDecision(humidity, location);
    }

    if (windSpeed > 40) {
      await _createStrongWindDecision(windSpeed, location);
    }

    if (condition.toLowerCase().contains('heavy rain') ||
        condition.toLowerCase().contains('thunderstorm')) {
      await _createHeavyRainDecision(condition, location);
    }
  }

  /// Analyze weather forecast
  static Future<void> _analyzeForecast(
    List<Map<String, dynamic>> forecast,
    String location,
  ) async {
    if (forecast.isEmpty) return;

    // Look for upcoming extreme conditions in next 3 days
    final upcomingDays = forecast.take(3).toList();

    for (int i = 0; i < upcomingDays.length; i++) {
      final day = upcomingDays[i];
      final high = day['high'] as int? ?? 0;
      final low = day['low'] as int? ?? 0;
      final condition = day['condition'] as String? ?? '';
      final precipitation = day['precipitation'] as double? ?? 0;
      final daysAhead = i + 1;

      // Frost warning
      if (low <= 5) {
        await _createUpcomingFrostWarning(low, daysAhead, location);
      }

      // Heat warning
      if (high >= 40) {
        await _createUpcomingHeatWarning(high, daysAhead, location);
      }

      // Heavy rain warning
      if (precipitation > 50 ||
          condition.toLowerCase().contains('heavy rain') ||
          condition.toLowerCase().contains('thunderstorm')) {
        await _createUpcomingRainWarning(precipitation, daysAhead, location);
      }

      // Dry spell warning
      if (precipitation == 0 && _isDryForecast(upcomingDays)) {
        await _createDrySpellWarning(upcomingDays.length, location);
        break; // Only create once
      }
    }
  }

  /// Check if forecast shows dry conditions
  static bool _isDryForecast(List<Map<String, dynamic>> forecast) {
    return forecast
        .every((day) => (day['precipitation'] as double? ?? 0) < 2);
  }

  /// Analyze weather alerts
  static Future<void> _analyzeAlerts(
    List<Map<String, dynamic>> alerts,
    String location,
  ) async {
    for (final alert in alerts) {
      final type = alert['type'] as String? ?? '';
      final message = alert['message'] as String? ?? '';
      final severity = alert['severity'] as String? ?? 'Medium';

      await _createAlertDecision(type, message, severity, location);
    }
  }

  /// Generate actionable insights
  static Future<void> _generateInsights(
    Map<String, dynamic> currentWeather,
    List<Map<String, dynamic>> forecast,
    String location,
  ) async {
    // Optimal farming activities based on weather
    final temp = currentWeather['temperature'] as int? ?? 0;
    final condition = currentWeather['condition'] as String? ?? '';

    // Good conditions for field work
    if (temp > 15 &&
        temp < 35 &&
        !condition.toLowerCase().contains('rain') &&
        !condition.toLowerCase().contains('storm')) {
      await _createFieldWorkInsight(temp, condition, location);
    }

    // Irrigation recommendation
    final upcomingRain = forecast
        .take(3)
        .any((day) => (day['precipitation'] as double? ?? 0) > 5);
    if (!upcomingRain && temp > 25) {
      await _createIrrigationInsight(temp, location);
    }

    // Pest management timing
    if (temp > 20 && temp < 30) {
      final humidity = currentWeather['humidity'] as int? ?? 0;
      if (humidity > 70) {
        await _createPestManagementInsight(temp, humidity, location);
      }
    }
  }

  // ==================== DECISION CREATORS ====================

  static Future<void> _createHeatWaveDecision(int temp, String location) async {
    final decision = AgentDecision(
      id: 'weather_heat_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Heat Wave Alert',
      message:
          'Temperature is extremely high ($temp°C). Ensure adequate irrigation for your crops and avoid field work during peak hours.',
      reasoning:
          'High temperatures can stress crops and lead to water deficiency. Immediate action required.',
      priority: AgentPriority.critical,
      confidence: 0.95,
      data: {'temperature': temp, 'location': location},
      actions: ['Increase irrigation', 'Provide shade for sensitive crops', 'Avoid midday field work'],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createFrostWarningDecision(int temp, String location) async {
    final decision = AgentDecision(
      id: 'weather_frost_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Frost Warning',
      message:
          'Temperature is near freezing ($temp°C). Protect sensitive crops immediately to prevent frost damage.',
      reasoning:
          'Frost can severely damage or kill sensitive plants. Protective measures must be taken.',
      priority: AgentPriority.critical,
      confidence: 0.95,
      data: {'temperature': temp, 'location': location},
      actions: ['Cover sensitive crops', 'Use frost protection methods', 'Move potted plants indoors'],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createHighHumidityDecision(int humidity, String location) async {
    final decision = AgentDecision(
      id: 'weather_humidity_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'High Humidity Alert',
      message:
          'Humidity level is very high ($humidity%). Monitor crops for fungal diseases and improve air circulation.',
      reasoning:
          'High humidity creates favorable conditions for fungal and bacterial diseases.',
      priority: AgentPriority.high,
      confidence: 0.85,
      data: {'humidity': humidity, 'location': location},
      actions: [
        'Check for fungal infections',
        'Improve air circulation',
        'Consider preventive fungicide'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createStrongWindDecision(double windSpeed, String location) async {
    final decision = AgentDecision(
      id: 'weather_wind_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Strong Wind Warning',
      message:
          'Strong winds detected (${windSpeed.toStringAsFixed(1)} km/h). Secure loose equipment and support tall plants.',
      reasoning: 'Strong winds can damage crops and farm infrastructure.',
      priority: AgentPriority.high,
      confidence: 0.9,
      data: {'wind_speed': windSpeed, 'location': location},
      actions: [
        'Stake tall plants',
        'Secure equipment',
        'Postpone spraying activities'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createHeavyRainDecision(String condition, String location) async {
    final decision = AgentDecision(
      id: 'weather_rain_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Heavy Rain Alert',
      message:
          '$condition expected. Ensure proper drainage and protect harvested crops from water damage.',
      reasoning: 'Heavy rain can cause waterlogging and damage to crops.',
      priority: AgentPriority.high,
      confidence: 0.9,
      data: {'condition': condition, 'location': location},
      actions: [
        'Check drainage systems',
        'Cover harvested crops',
        'Postpone field operations'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createUpcomingFrostWarning(
      int temp, int daysAhead, String location) async {
    final decision = AgentDecision(
      id: 'weather_upcoming_frost_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Upcoming Frost Warning',
      message:
          'Frost conditions expected in $daysAhead days ($temp°C). Prepare protective measures for sensitive crops.',
      reasoning:
          'Advance warning allows time to prepare frost protection measures.',
      priority: daysAhead == 1 ? AgentPriority.high : AgentPriority.medium,
      confidence: 0.8,
      data: {'temperature': temp, 'days_ahead': daysAhead, 'location': location},
      actions: [
        'Prepare frost covers',
        'Check frost protection equipment',
        'Move sensitive plants if possible'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createUpcomingHeatWarning(
      int temp, int daysAhead, String location) async {
    final decision = AgentDecision(
      id: 'weather_upcoming_heat_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Upcoming Heat Wave',
      message:
          'High temperatures expected in $daysAhead days ($temp°C). Plan for increased irrigation needs.',
      reasoning: 'Advance planning helps ensure adequate water supply during heat.',
      priority: AgentPriority.medium,
      confidence: 0.75,
      data: {'temperature': temp, 'days_ahead': daysAhead, 'location': location},
      actions: [
        'Check irrigation system',
        'Ensure water supply',
        'Plan for increased watering'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createUpcomingRainWarning(
      double precipitation, int daysAhead, String location) async {
    final decision = AgentDecision(
      id: 'weather_upcoming_rain_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Heavy Rain Forecast',
      message:
          'Heavy rainfall expected in $daysAhead days (${precipitation.toStringAsFixed(1)}mm). Prepare drainage and protect crops.',
      reasoning: 'Advance warning allows preparation for heavy rain.',
      priority: daysAhead == 1 ? AgentPriority.high : AgentPriority.medium,
      confidence: 0.75,
      data: {
        'precipitation': precipitation,
        'days_ahead': daysAhead,
        'location': location
      },
      actions: [
        'Clear drainage channels',
        'Prepare rain covers',
        'Delay irrigation'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createDrySpellWarning(int days, String location) async {
    final decision = AgentDecision(
      id: 'weather_dry_spell_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Dry Weather Ahead',
      message:
          'No rain forecasted for next $days days. Plan irrigation schedule carefully.',
      reasoning: 'Extended dry period requires proactive water management.',
      priority: AgentPriority.medium,
      confidence: 0.7,
      data: {'dry_days': days, 'location': location},
      actions: [
        'Plan irrigation schedule',
        'Check water reserves',
        'Consider mulching to retain moisture'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createAlertDecision(
    String type,
    String message,
    String severity,
    String location,
  ) async {
    final priority = severity == 'High'
        ? AgentPriority.critical
        : severity == 'Medium'
            ? AgentPriority.high
            : AgentPriority.medium;

    final decision = AgentDecision(
      id: 'weather_alert_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: type,
      message: message,
      reasoning: 'Official weather alert requires attention',
      priority: priority,
      confidence: 0.9,
      data: {'alert_type': type, 'severity': severity, 'location': location},
      actions: ['Review alert details', 'Take recommended precautions'],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  // ==================== INSIGHT CREATORS ====================

  static Future<void> _createFieldWorkInsight(
      int temp, String condition, String location) async {
    final insight = AgentInsight(
      id: 'weather_fieldwork_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Good Weather for Field Work',
      description:
          'Weather conditions are favorable today ($temp°C, $condition). Consider scheduling outdoor farm activities.',
      actionText: 'Plan Activities',
      actionData: {'temperature': temp, 'condition': condition},
      priority: AgentPriority.low,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 12)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createIrrigationInsight(int temp, String location) async {
    final insight = AgentInsight(
      id: 'weather_irrigation_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Irrigation Recommended',
      description:
          'No rain expected and temperature is high ($temp°C). Consider watering your crops today.',
      actionText: 'Schedule Irrigation',
      actionData: {'temperature': temp, 'reason': 'no_rain_high_temp'},
      priority: AgentPriority.medium,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createPestManagementInsight(
      int temp, int humidity, String location) async {
    final insight = AgentInsight(
      id: 'weather_pest_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Optimal Pest Management Timing',
      description:
          'Weather conditions ($temp°C, $humidity% humidity) are favorable for pest control spraying.',
      actionText: 'Schedule Pest Control',
      actionData: {'temperature': temp, 'humidity': humidity},
      priority: AgentPriority.low,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 8)),
    );

    await AgentService.saveInsight(insight);
  }

  /// Schedule regular weather analysis
  static Future<void> scheduleAnalysis(String location) async {
    final task = AgentTask(
      id: 'weather_analysis_${DateTime.now().millisecondsSinceEpoch}',
      type: agentType,
      name: 'Weather Analysis',
      description: 'Analyze weather conditions and generate alerts',
      context: {'location': location},
      scheduledTime: DateTime.now().add(const Duration(minutes: 30)),
      priority: AgentPriority.high,
      status: AgentTaskStatus.pending,
      createdAt: DateTime.now(),
    );

    await AgentService.scheduleTask(task);
  }
}
