import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/agent_models.dart';
import '../secrets.dart';
import 'dart:convert';

/// AI-powered decision engine using Gemini for intelligent agent reasoning
class AgentDecisionEngine {
  static GenerativeModel? _model;
  static bool _initialized = false;

  /// Initialize the decision engine with Gemini
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: geminiApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );

      _initialized = true;

      if (kDebugMode) {
        print('AgentDecisionEngine initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing AgentDecisionEngine: $e');
      }
    }
  }

  /// Generate AI-powered decision with context awareness
  static Future<Map<String, dynamic>> analyzeAndDecide({
    required AgentType agentType,
    required Map<String, dynamic> context,
    required String question,
    String language = 'en',
  }) async {
    if (!_initialized) {
      await initialize();
    }

    if (_model == null) {
      throw Exception('Decision engine not initialized');
    }

    try {
      // Build context-aware prompt
      final prompt = _buildPrompt(
        agentType: agentType,
        context: context,
        question: question,
        language: language,
      );

      // Generate response from Gemini
      final response = await _model!.generateContent([Content.text(prompt)]);
      final responseText = response.text?.trim() ?? '';

      if (responseText.isEmpty) {
        throw Exception('Empty response from AI');
      }

      // Parse AI response
      return _parseResponse(responseText, agentType);
    } catch (e) {
      if (kDebugMode) {
        print('Error in AI decision: $e');
      }
      // Return fallback decision
      return _getFallbackDecision(agentType, context);
    }
  }

  /// Build intelligent prompt based on agent type and context
  static String _buildPrompt({
    required AgentType agentType,
    required Map<String, dynamic> context,
    required String question,
    required String language,
  }) {
    final languageName = _getLanguageName(language);
    final contextStr = _formatContext(context);

    final basePrompt = '''
You are FarmSphere AI Agent, an expert farming assistant. You must respond in $languageName language.

Agent Type: ${agentType.name}
Context: $contextStr

Question: $question

Provide a structured response in JSON format with the following fields:
{
  "title": "Brief title for the recommendation",
  "message": "Detailed message in $languageName",
  "reasoning": "Why this recommendation makes sense",
  "priority": "low|medium|high|critical",
  "confidence": 0.0 to 1.0,
  "actions": ["action1", "action2", "action3"]
}

Guidelines:
- Be specific and actionable
- Consider local Indian farming conditions
- Use simple, clear language
- Prioritize farmer safety and crop health
- Consider seasonal factors
- Provide 3-5 actionable steps
''';

    return basePrompt;
  }

  /// Format context data for prompt
  static String _formatContext(Map<String, dynamic> context) {
    final buffer = StringBuffer();

    for (final entry in context.entries) {
      buffer.writeln('- ${entry.key}: ${_formatValue(entry.value)}');
    }

    return buffer.toString();
  }

  /// Format individual context values
  static String _formatValue(dynamic value) {
    if (value is List) {
      return value.take(5).join(', ') +
          (value.length > 5 ? '... (${value.length} total)' : '');
    } else if (value is Map) {
      return value.entries
          .take(3)
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');
    }
    return value.toString();
  }

  /// Parse AI response into structured decision
  static Map<String, dynamic> _parseResponse(
    String responseText,
    AgentType agentType,
  ) {
    try {
      // Try to extract JSON from response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(responseText);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final parsed = jsonDecode(jsonStr);

        return {
          'title': parsed['title'] ?? 'AI Recommendation',
          'message': parsed['message'] ?? responseText,
          'reasoning': parsed['reasoning'] ?? 'Based on current conditions',
          'priority': _parsePriority(parsed['priority']),
          'confidence': (parsed['confidence'] as num?)?.toDouble() ?? 0.7,
          'actions': List<String>.from(parsed['actions'] ?? []),
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing AI response: $e');
      }
    }

    // Fallback: use raw text
    return {
      'title': 'AI Recommendation',
      'message': responseText,
      'reasoning': 'AI analysis of current situation',
      'priority': AgentPriority.medium,
      'confidence': 0.6,
      'actions': _extractActionsFromText(responseText),
    };
  }

  /// Parse priority string to enum
  static AgentPriority _parsePriority(dynamic priority) {
    if (priority is String) {
      switch (priority.toLowerCase()) {
        case 'critical':
          return AgentPriority.critical;
        case 'high':
          return AgentPriority.high;
        case 'medium':
          return AgentPriority.medium;
        case 'low':
          return AgentPriority.low;
      }
    }
    return AgentPriority.medium;
  }

  /// Extract action items from text
  static List<String> _extractActionsFromText(String text) {
    final actions = <String>[];

    // Look for numbered lists
    final numberPattern = RegExp(r'^\d+[\.)]\s*(.+)$', multiLine: true);
    final numberMatches = numberPattern.allMatches(text);

    for (final match in numberMatches) {
      final action = match.group(1)?.trim();
      if (action != null && action.isNotEmpty) {
        actions.add(action);
      }
    }

    // Look for bullet points
    if (actions.isEmpty) {
      final bulletPattern = RegExp(r'^[\-\*]\s*(.+)$', multiLine: true);
      final bulletMatches = bulletPattern.allMatches(text);

      for (final match in bulletMatches) {
        final action = match.group(1)?.trim();
        if (action != null && action.isNotEmpty) {
          actions.add(action);
        }
      }
    }

    return actions.take(5).toList();
  }

  /// Get fallback decision when AI fails
  static Map<String, dynamic> _getFallbackDecision(
    AgentType agentType,
    Map<String, dynamic> context,
  ) {
    return {
      'title': 'Recommendation',
      'message': 'Based on current conditions, monitor your crops regularly and maintain good farming practices.',
      'reasoning': 'General farming best practices',
      'priority': AgentPriority.medium,
      'confidence': 0.5,
      'actions': [
        'Monitor crops regularly',
        'Maintain proper irrigation',
        'Check for pests and diseases'
      ],
    };
  }

  /// Get language name from code
  static String _getLanguageName(String code) {
    const languageNames = {
      'en': 'English',
      'hi': 'Hindi',
      'bn': 'Bengali',
      'ta': 'Tamil',
      'te': 'Telugu',
      'mr': 'Marathi',
      'gu': 'Gujarati',
      'kn': 'Kannada',
      'ml': 'Malayalam',
      'pa': 'Punjabi',
      'ur': 'Urdu',
    };
    return languageNames[code] ?? 'English';
  }

  /// Generate weather-specific recommendation
  static Future<Map<String, dynamic>> analyzeWeather({
    required Map<String, dynamic> currentWeather,
    required List<Map<String, dynamic>> forecast,
    required String location,
    String language = 'en',
  }) async {
    final context = {
      'current_temperature': currentWeather['temperature'],
      'current_condition': currentWeather['condition'],
      'humidity': currentWeather['humidity'],
      'forecast_summary': forecast.take(3).map((f) {
        return '${f['condition']}, High: ${f['high']}°C, Low: ${f['low']}°C';
      }).join('; '),
      'location': location,
    };

    return await analyzeAndDecide(
      agentType: AgentType.weather,
      context: context,
      question:
          'What farming activities should be recommended based on this weather?',
      language: language,
    );
  }

  /// Generate activity-specific recommendation
  static Future<Map<String, dynamic>> analyzeActivitySchedule({
    required String crop,
    required int daysSinceLastActivity,
    required String activityType,
    required Map<String, dynamic>? weatherData,
    String language = 'en',
  }) async {
    final context = {
      'crop': crop,
      'days_since_activity': daysSinceLastActivity,
      'activity_type': activityType,
      'weather_condition': weatherData?['condition'] ?? 'Unknown',
      'temperature': weatherData?['temperature'] ?? 'Unknown',
    };

    return await analyzeAndDecide(
      agentType: AgentType.activity,
      context: context,
      question:
          'Should the farmer perform $activityType for $crop now? What is the optimal timing?',
      language: language,
    );
  }

  /// Generate crop health recommendation
  static Future<Map<String, dynamic>> analyzeCropHealth({
    required String disease,
    required int occurrences,
    required String severity,
    String language = 'en',
  }) async {
    final context = {
      'disease': disease,
      'occurrences': occurrences,
      'severity': severity,
    };

    return await analyzeAndDecide(
      agentType: AgentType.cropHealth,
      context: context,
      question:
          'What preventive measures and treatment should be recommended for this recurring crop disease?',
      language: language,
    );
  }

  /// Generate market recommendation
  static Future<Map<String, dynamic>> analyzeMarket({
    required String crop,
    required double currentPrice,
    required double avgPrice,
    required double trendPercent,
    String language = 'en',
  }) async {
    final context = {
      'crop': crop,
      'current_price': '₹$currentPrice/quintal',
      'average_price': '₹$avgPrice/quintal',
      'price_trend': '${trendPercent > 0 ? '+' : ''}${trendPercent.toStringAsFixed(1)}%',
    };

    return await analyzeAndDecide(
      agentType: AgentType.market,
      context: context,
      question:
          'Should the farmer sell $crop now or wait? What is the market outlook?',
      language: language,
    );
  }

  /// Generate resource optimization recommendation
  static Future<Map<String, dynamic>> analyzeResourceUsage({
    required Map<String, dynamic> usageData,
    required String focusArea,
    String language = 'en',
  }) async {
    final context = {
      'focus_area': focusArea,
      ...usageData,
    };

    return await analyzeAndDecide(
      agentType: AgentType.resource,
      context: context,
      question:
          'How can the farmer optimize $focusArea usage to reduce costs and improve efficiency?',
      language: language,
    );
  }

  /// Batch analyze multiple questions (cost-efficient)
  static Future<List<Map<String, dynamic>>> batchAnalyze({
    required List<Map<String, dynamic>> questions,
    String language = 'en',
  }) async {
    final results = <Map<String, dynamic>>[];

    // Process questions sequentially to avoid rate limits
    for (final q in questions) {
      try {
        final result = await analyzeAndDecide(
          agentType: q['agentType'] as AgentType,
          context: q['context'] as Map<String, dynamic>,
          question: q['question'] as String,
          language: language,
        );
        results.add(result);

        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        if (kDebugMode) {
          print('Error in batch analysis: $e');
        }
        results.add(_getFallbackDecision(
          q['agentType'] as AgentType,
          q['context'] as Map<String, dynamic>,
        ));
      }
    }

    return results;
  }
}
