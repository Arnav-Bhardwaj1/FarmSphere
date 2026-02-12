import 'package:flutter/foundation.dart';
import '../models/agent_models.dart';
import '../services/msp_service.dart';
import '../services/agent_service.dart';
import '../services/agent_database.dart';

/// Market Intelligence Agent - Tracks prices and suggests optimal selling times
class MarketAgent {
  static const AgentType agentType = AgentType.market;

  // Store price history for trend analysis
  static final Map<String, List<Map<String, dynamic>>> _priceHistory = {};

  /// Analyze market prices and generate insights
  static Future<void> analyze({
    required List<String> trackedCrops,
    String? userId,
  }) async {
    if (kDebugMode) {
      print('MarketAgent: Starting analysis');
    }

    try {
      // Check if agent is enabled
      final isEnabled = await AgentDatabase.isAgentEnabled(agentType);
      if (!isEnabled) {
        if (kDebugMode) {
          print('MarketAgent: Agent is disabled');
        }
        return;
      }

      // Fetch current market prices
      final mspPrices = await MSPService.getMSPPrices();
      final marketPrices = await MSPService.getMarketPrices();
      final allPrices = [...mspPrices, ...marketPrices];

      // Update price history
      _updatePriceHistory(allPrices);

      // Analyze price trends
      await _analyzePriceTrends(trackedCrops);

      // Find selling opportunities
      await _findSellingOpportunities(trackedCrops);

      // Generate market insights
      await _generateMarketInsights(allPrices);

      // Compare MSP vs Market prices
      await _compareMSPPrices(mspPrices, marketPrices);

      if (kDebugMode) {
        print('MarketAgent: Analysis completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('MarketAgent: Error during analysis - $e');
      }
    }
  }

  /// Update price history for trend analysis
  static void _updatePriceHistory(List<Map<String, dynamic>> prices) {
    final timestamp = DateTime.now();

    for (final priceData in prices) {
      final crop = priceData['crop'] as String? ?? priceData['name'] as String? ?? 'Unknown';
      final price = priceData['price'] as num? ?? 0;

      _priceHistory.putIfAbsent(crop, () => []);
      _priceHistory[crop]!.add({
        'price': price,
        'timestamp': timestamp.toIso8601String(),
      });

      // Keep only last 30 data points
      if (_priceHistory[crop]!.length > 30) {
        _priceHistory[crop]!.removeAt(0);
      }
    }
  }

  /// Analyze price trends for tracked crops
  static Future<void> _analyzePriceTrends(List<String> trackedCrops) async {
    for (final crop in trackedCrops) {
      final history = _priceHistory[crop];
      if (history == null || history.length < 3) continue;

      // Calculate trend
      final recentPrices = history.takeLast(5).map((h) => h['price'] as num).toList();
      final avgRecent = recentPrices.reduce((a, b) => a + b) / recentPrices.length;

      final olderPrices =
          history.take(history.length - 5).map((h) => h['price'] as num).toList();
      if (olderPrices.isEmpty) continue;

      final avgOlder = olderPrices.reduce((a, b) => a + b) / olderPrices.length;

      final changePercent = ((avgRecent - avgOlder) / avgOlder) * 100;

      // Alert if significant price change
      if (changePercent.abs() > 10) {
        await _createPriceTrendAlert(crop, changePercent, avgRecent.toDouble());
      }
    }
  }

  /// Find optimal selling opportunities
  static Future<void> _findSellingOpportunities(List<String> trackedCrops) async {
    for (final crop in trackedCrops) {
      final history = _priceHistory[crop];
      if (history == null || history.length < 10) continue;

      final allPrices = history.map((h) => h['price'] as num).toList();
      final avgPrice = allPrices.reduce((a, b) => a + b) / allPrices.length;
      final currentPrice = allPrices.last;

      // If current price is significantly above average, suggest selling
      final priceAboveAvg = ((currentPrice - avgPrice) / avgPrice) * 100;

      if (priceAboveAvg > 15) {
        await _createSellingOpportunityAlert(
          crop,
          currentPrice.toDouble(),
          avgPrice.toDouble(),
          priceAboveAvg,
        );
      }

      // Check for peak prices
      final maxPrice = allPrices.reduce((a, b) => a > b ? a : b);
      if (currentPrice >= maxPrice * 0.95) {
        // Within 5% of historical max
        await _createPeakPriceAlert(crop, currentPrice.toDouble());
      }
    }
  }

  /// Generate general market insights
  static Future<void> _generateMarketInsights(
    List<Map<String, dynamic>> prices,
  ) async {
    if (prices.isEmpty) return;

    // Find crops with highest and lowest prices
    final sortedPrices = List<Map<String, dynamic>>.from(prices)
      ..sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));

    // High value crops
    final topCrops = sortedPrices.take(3).toList();
    if (topCrops.isNotEmpty) {
      await _createHighValueCropsInsight(topCrops);
    }

    // Seasonal market insights
    await _generateSeasonalMarketInsights();
  }

  /// Compare MSP vs Market prices
  static Future<void> _compareMSPPrices(
    List<Map<String, dynamic>> mspPrices,
    List<Map<String, dynamic>> marketPrices,
  ) async {
    for (final mspData in mspPrices) {
      final crop = mspData['crop'] as String? ?? mspData['name'] as String? ?? '';
      final mspPrice = mspData['price'] as num? ?? 0;

      // Find corresponding market price
      final marketData = marketPrices.firstWhere(
        (m) =>
            (m['crop'] as String? ?? m['name'] as String? ?? '')
                .toLowerCase() ==
            crop.toLowerCase(),
        orElse: () => {},
      );

      if (marketData.isNotEmpty) {
        final marketPrice = marketData['price'] as num? ?? 0;

        // Alert if market price is significantly below MSP
        if (marketPrice < mspPrice * 0.9) {
          // 10% below MSP
          await _createMSPComparisonAlert(
            crop,
            mspPrice.toDouble(),
            marketPrice.toDouble(),
          );
        }
      }
    }
  }

  /// Generate seasonal market insights
  static Future<void> _generateSeasonalMarketInsights() async {
    final month = DateTime.now().month;

    String season;
    String insights;
    List<String> recommendedCrops;

    if (month >= 3 && month <= 6) {
      // Summer harvest season
      season = 'Summer Harvest';
      insights =
          'Wheat and rabi crop prices typically peak during this period. Consider selling stored produce before prices drop in monsoon season.';
      recommendedCrops = ['Wheat', 'Barley', 'Mustard'];
    } else if (month >= 7 && month <= 10) {
      // Monsoon season
      season = 'Monsoon Season';
      insights =
          'Vegetable prices often increase due to supply constraints. Good time to sell perishable produce. Plan for kharif crop harvesting.';
      recommendedCrops = ['Tomato', 'Onion', 'Green vegetables'];
    } else if (month >= 11 || month <= 2) {
      // Winter season
      season = 'Winter Season';
      insights =
          'Rice and kharif crop prices stabilize. Good time to plan for rabi planting. Winter vegetables have steady demand.';
      recommendedCrops = ['Rice', 'Cotton', 'Winter vegetables'];
    } else {
      season = 'Transition Period';
      insights = 'Monitor market trends closely during seasonal transitions.';
      recommendedCrops = [];
    }

    await _createSeasonalMarketInsight(season, insights, recommendedCrops);
  }

  // ==================== DECISION CREATORS ====================

  static Future<void> _createPriceTrendAlert(
    String crop,
    double changePercent,
    double currentPrice,
  ) async {
    final isIncrease = changePercent > 0;
    final priority = changePercent.abs() > 20
        ? AgentPriority.high
        : AgentPriority.medium;

    final decision = AgentDecision(
      id: 'market_trend_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: '${isIncrease ? 'Rising' : 'Falling'} $crop Prices',
      message:
          '$crop prices have ${isIncrease ? 'increased' : 'decreased'} by ${changePercent.abs().toStringAsFixed(1)}% recently. Current price: ₹${currentPrice.toStringAsFixed(2)}/quintal.',
      reasoning:
          'Significant price movement detected based on recent market trends.',
      priority: priority,
      confidence: 0.8,
      data: {
        'crop': crop,
        'change_percent': changePercent,
        'current_price': currentPrice,
        'direction': isIncrease ? 'up' : 'down',
      },
      actions: isIncrease
          ? ['Consider selling', 'Check market rates', 'Monitor trend']
          : ['Hold for better prices', 'Store safely', 'Check forecast'],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createSellingOpportunityAlert(
    String crop,
    double currentPrice,
    double avgPrice,
    double percentAboveAvg,
  ) async {
    final decision = AgentDecision(
      id: 'market_opportunity_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'Good Time to Sell $crop',
      message:
          '$crop price (₹${currentPrice.toStringAsFixed(2)}) is ${percentAboveAvg.toStringAsFixed(1)}% above average (₹${avgPrice.toStringAsFixed(2)}). Consider selling now.',
      reasoning:
          'Current price is significantly above historical average, indicating a favorable selling opportunity.',
      priority: AgentPriority.high,
      confidence: 0.85,
      data: {
        'crop': crop,
        'current_price': currentPrice,
        'avg_price': avgPrice,
        'percent_above': percentAboveAvg,
      },
      actions: [
        'Sell now',
        'Check local mandis',
        'Compare buyer rates',
        'Negotiate better price'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createPeakPriceAlert(
    String crop,
    double currentPrice,
  ) async {
    final decision = AgentDecision(
      id: 'market_peak_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: '$crop at Peak Price',
      message:
          '$crop has reached near-peak price (₹${currentPrice.toStringAsFixed(2)}). Excellent opportunity to sell.',
      reasoning: 'Price is at or near historical maximum for this crop.',
      priority: AgentPriority.critical,
      confidence: 0.9,
      data: {
        'crop': crop,
        'current_price': currentPrice,
      },
      actions: [
        'Sell immediately',
        'Check multiple buyers',
        'Get quality grading',
        'Negotiate premium'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  static Future<void> _createMSPComparisonAlert(
    String crop,
    double mspPrice,
    double marketPrice,
  ) async {
    final decision = AgentDecision(
      id: 'market_msp_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: '$crop Market Price Below MSP',
      message:
          'Market price (₹${marketPrice.toStringAsFixed(2)}) is below MSP (₹${mspPrice.toStringAsFixed(2)}). Consider selling at government procurement centers.',
      reasoning:
          'Government MSP provides better returns when market prices are low.',
      priority: AgentPriority.high,
      confidence: 0.95,
      data: {
        'crop': crop,
        'msp_price': mspPrice,
        'market_price': marketPrice,
        'difference': mspPrice - marketPrice,
      },
      actions: [
        'Find govt. procurement center',
        'Check MSP eligibility',
        'Prepare documents',
        'Ensure quality standards'
      ],
      createdAt: DateTime.now(),
    );

    await AgentService.saveDecision(decision);
  }

  // ==================== INSIGHT CREATORS ====================

  static Future<void> _createHighValueCropsInsight(
    List<Map<String, dynamic>> topCrops,
  ) async {
    final cropNames = topCrops
        .map((c) => c['crop'] as String? ?? c['name'] as String? ?? '')
        .join(', ');

    final insight = AgentInsight(
      id: 'market_high_value_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: 'High Value Crops This Week',
      description:
          'Top earning crops: $cropNames. Consider focusing on these for your next planting season.',
      actionText: 'View Prices',
      actionData: {'top_crops': topCrops},
      priority: AgentPriority.low,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    await AgentService.saveInsight(insight);
  }

  static Future<void> _createSeasonalMarketInsight(
    String season,
    String insights,
    List<String> recommendedCrops,
  ) async {
    final insight = AgentInsight(
      id: 'market_seasonal_${DateTime.now().millisecondsSinceEpoch}',
      agentType: agentType,
      title: '$season Market Insights',
      description: insights,
      actionText: 'Learn More',
      actionData: {
        'season': season,
        'recommended_crops': recommendedCrops,
      },
      priority: AgentPriority.medium,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await AgentService.saveInsight(insight);
  }

  /// Schedule regular market analysis
  static Future<void> scheduleAnalysis(List<String> trackedCrops) async {
    final task = AgentTask(
      id: 'market_analysis_${DateTime.now().millisecondsSinceEpoch}',
      type: agentType,
      name: 'Market Analysis',
      description: 'Analyze market prices and identify opportunities',
      context: {'tracked_crops': trackedCrops},
      scheduledTime: DateTime.now().add(const Duration(hours: 4)),
      priority: AgentPriority.medium,
      status: AgentTaskStatus.pending,
      createdAt: DateTime.now(),
    );

    await AgentService.scheduleTask(task);
  }

  /// Get tracked crops from user preferences
  static Future<List<String>> getTrackedCrops() async {
    final settings = await AgentDatabase.getSettings(agentType);
    if (settings != null) {
      final crops = settings.preferences['track_crops'] as List?;
      if (crops != null) {
        return List<String>.from(crops);
      }
    }
    // Default tracked crops
    return ['Rice', 'Wheat', 'Tomato', 'Potato', 'Onion'];
  }

  /// Update tracked crops
  static Future<void> updateTrackedCrops(List<String> crops) async {
    final settings = await AgentDatabase.getSettings(agentType) ??
        AgentSettings(
          agentType: agentType,
          enabled: true,
          preferences: {},
          lastUpdated: DateTime.now(),
        );

    final updatedPreferences = Map<String, dynamic>.from(settings.preferences);
    updatedPreferences['track_crops'] = crops;

    await AgentDatabase.saveSettings(settings.copyWith(
      preferences: updatedPreferences,
      lastUpdated: DateTime.now(),
    ));
  }
}

// Extension to get last N elements from a list
extension ListExtension<T> on List<T> {
  List<T> takeLast(int n) {
    if (n >= length) return this;
    return sublist(length - n);
  }
}
