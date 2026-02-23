import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/agent_models.dart';
import '../services/agent_service.dart';
import '../services/agent_decision_engine.dart';

// Agent State
class AgentState {
  final Map<AgentType, bool> agentStatuses;
  final List<AgentInsight> activeInsights;
  final List<AgentDecision> recentDecisions;
  final List<AgentDecision> unacknowledgedDecisions;
  final Map<String, dynamic> statistics;
  final bool isLoading;
  final String? error;

  AgentState({
    this.agentStatuses = const {},
    this.activeInsights = const [],
    this.recentDecisions = const [],
    this.unacknowledgedDecisions = const [],
    this.statistics = const {},
    this.isLoading = false,
    this.error,
  });

  AgentState copyWith({
    Map<AgentType, bool>? agentStatuses,
    List<AgentInsight>? activeInsights,
    List<AgentDecision>? recentDecisions,
    List<AgentDecision>? unacknowledgedDecisions,
    Map<String, dynamic>? statistics,
    bool? isLoading,
    String? error,
  }) {
    return AgentState(
      agentStatuses: agentStatuses ?? this.agentStatuses,
      activeInsights: activeInsights ?? this.activeInsights,
      recentDecisions: recentDecisions ?? this.recentDecisions,
      unacknowledgedDecisions:
          unacknowledgedDecisions ?? this.unacknowledgedDecisions,
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Agent Notifier
class AgentNotifier extends StateNotifier<AgentState> {
  AgentNotifier() : super(AgentState()) {
    _initialize();
  }

  /// Initialize agent system
  Future<void> _initialize() async {
    try {
      await AgentService.initialize();
      await AgentDecisionEngine.initialize();
      await loadAgentData();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing agents: $e');
      }
      state = state.copyWith(error: e.toString());
    }
  }

  /// Load all agent data
  Future<void> loadAgentData() async {
    state = state.copyWith(isLoading: true);

    try {
      final statuses = await AgentService.getAgentStatuses();
      final insights = await AgentService.getActiveInsights();
      final decisions = await AgentService.getRecentDecisions(limit: 20);
      final unacknowledged = await AgentService.getUnacknowledgedDecisions();
      final stats = await AgentService.getStatistics();

      state = state.copyWith(
        agentStatuses: statuses,
        activeInsights: insights,
        recentDecisions: decisions,
        unacknowledgedDecisions: unacknowledged,
        statistics: stats,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error loading agent data: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Enable or disable an agent
  Future<void> toggleAgent(AgentType agentType, bool enabled) async {
    try {
      await AgentService.setAgentEnabled(agentType, enabled);

      final updatedStatuses = Map<AgentType, bool>.from(state.agentStatuses);
      updatedStatuses[agentType] = enabled;

      state = state.copyWith(agentStatuses: updatedStatuses);
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling agent: $e');
      }
      state = state.copyWith(error: e.toString());
    }
  }

  /// Acknowledge a decision
  Future<void> acknowledgeDecision(String decisionId) async {
    try {
      await AgentService.acknowledgeDecision(decisionId);

      // Remove from unacknowledged list
      final updatedUnacknowledged = state.unacknowledgedDecisions
          .where((d) => d.id != decisionId)
          .toList();

      state = state.copyWith(unacknowledgedDecisions: updatedUnacknowledged);
    } catch (e) {
      if (kDebugMode) {
        print('Error acknowledging decision: $e');
      }
    }
  }

  /// Dismiss an insight
  Future<void> dismissInsight(String insightId) async {
    try {
      await AgentService.dismissInsight(insightId);

      // Remove from active insights
      final updatedInsights =
          state.activeInsights.where((i) => i.id != insightId).toList();

      state = state.copyWith(activeInsights: updatedInsights);
    } catch (e) {
      if (kDebugMode) {
        print('Error dismissing insight: $e');
      }
    }
  }

  /// Run agents manually
  Future<void> runAgentsNow() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Execute agents and ensure minimum 5 second loading time
      await Future.wait([
        AgentService.runAgentsNow(),
        Future.delayed(const Duration(seconds: 5)),
      ]);
      
      await loadAgentData(); // Refresh after running
      state = state.copyWith(isLoading: false);
    } catch (e) {
      if (kDebugMode) {
        print('Error running agents: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: e is UnsupportedError 
          ? 'AI Agents are not available on web. Please use the mobile or desktop app for full agent functionality.'
          : e.toString(),
      );
      rethrow; // Re-throw so the UI can show a snackbar
    }
  }

  /// Check and send pending notifications
  Future<void> checkNotifications() async {
    try {
      await AgentService.checkNotifications();
    } catch (e) {
      if (kDebugMode) {
        print('Error checking notifications: $e');
      }
    }
  }

  /// Send test notification
  Future<void> sendTestNotification() async {
    try {
      await AgentService.sendTestNotification();
    } catch (e) {
      if (kDebugMode) {
        print('Error sending test notification: $e');
      }
      state = state.copyWith(error: e.toString());
    }
  }

  /// Refresh all agent data
  Future<void> refresh() async {
    await loadAgentData();
  }
}

// Provider
final agentProvider = StateNotifierProvider<AgentNotifier, AgentState>((ref) {
  return AgentNotifier();
});
