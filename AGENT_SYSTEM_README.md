# FarmSphere AI Agent System

## Overview

The FarmSphere AI Agent System is an autonomous intelligence layer that proactively monitors your farm, analyzes data, and provides actionable recommendations without user intervention.

## Features

### 1. Weather Intelligence Agent
- **Real-time weather analysis** and critical alerts
- **Forecast-based recommendations** for farming activities
- **Seasonal adjustments** for optimal crop management
- **Priority alerts** for extreme conditions (frost, heatwave, storms)

### 2. Crop Health Monitoring Agent
- **Pattern detection** in disease occurrences
- **Preventive recommendations** based on history
- **Seasonal health tips** tailored to your region
- **Recurring issue alerts** with treatment suggestions

### 3. Activity Scheduling Agent
- **Learns your farming patterns** from activity history
- **Personalized schedules** for irrigation, fertilizing, pest control
- **Weather-aware recommendations** for optimal timing
- **Missed activity alerts** to keep you on track

### 4. Market Intelligence Agent
- **Price trend analysis** for tracked crops
- **Selling opportunity alerts** when prices peak
- **MSP vs Market comparison** for best returns
- **Seasonal market insights** for planning

### 5. Resource Optimization Agent
- **Water usage optimization** recommendations
- **Fertilizer efficiency** suggestions
- **Cost-saving measures** based on your patterns
- **Sustainability tips** for eco-friendly farming

## Installation & Setup

### Step 1: Dependencies

The required dependencies are already added to `pubspec.yaml`:
```yaml
workmanager: ^0.5.2
flutter_local_notifications: ^17.0.0
cron: ^0.6.0
flutter_native_timezone: ^2.0.0
```

Run:
```bash
flutter pub get
```

### Step 2: Initialize Agent System

In your `main.dart`, add the initialization:

```dart
import 'package:farmsphere/services/agent_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize agent system
  await AgentInit.initialize();
  
  runApp(const MyApp());
}
```

### Step 3: Add Agent Provider

In `lib/providers/app_providers.dart`, import the agent provider:

```dart
import 'agent_provider.dart';

// The agentProvider is already exported from agent_provider.dart
```

### Step 4: Configure Permissions

#### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<!-- Notifications -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>

<!-- Background execution -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

#### iOS (`ios/Runner/Info.plist`):
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

## Usage

### Accessing the Agent Dashboard

Add navigation to your app:

```dart
// In your navigation/routing
'/agents': (context) => const AgentDashboardScreen(),
'/agent-settings': (context) => const AgentSettingsScreen(),
```

### Displaying Insights on Home Screen

Add to your `home_screen.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/agent_provider.dart';
import '../widgets/agent_insight_card.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentState = ref.watch(agentProvider);
    final agentNotifier = ref.read(agentProvider.notifier);

    return Column(
      children: [
        // Show active insights
        ...agentState.activeInsights.take(3).map((insight) {
          return CompactAgentInsightCard(
            insight: insight,
            onTap: () {
              // Navigate to detailed view or perform action
            },
            onDismiss: () {
              agentNotifier.dismissInsight(insight.id);
            },
          );
        }),
        
        // Rest of your home screen content
      ],
    );
  }
}
```

### Running Agents Manually

```dart
// Get the agent notifier
final agentNotifier = ref.read(agentProvider.notifier);

// Run all agents now
await agentNotifier.runAgentsNow();

// Check and send pending notifications
await agentNotifier.checkNotifications();
```

### Triggering Specific Agents

```dart
import 'package:farmsphere/agents/weather_agent.dart';
import 'package:farmsphere/agents/activity_agent.dart';
import 'package:farmsphere/agents/crop_health_agent.dart';
import 'package:farmsphere/agents/market_agent.dart';

// Weather analysis
await WeatherAgent.analyze(location, userId: userId);

// Activity analysis
await ActivityAgent.analyze(
  activityHistory: activities,
  weatherData: weatherData,
  location: location,
  userId: userId,
);

// Crop health analysis
await CropHealthAgent.analyze(
  diagnosisHistory: diagnosisHistory,
  location: location,
  userId: userId,
);

// Market analysis
await MarketAgent.analyze(
  trackedCrops: ['Rice', 'Wheat', 'Tomato'],
  userId: userId,
);
```

## Performance Optimization

### Battery Optimization

1. **Adjust Check Frequency**
   - Critical agents (Weather, Crop Health): Every 30 minutes
   - Analytical agents (Market, Resource): Every 4 hours
   - Scheduling agent: Twice daily (morning/evening)

2. **Use Constraints**
   ```dart
   // In background_task_service.dart
   constraints: Constraints(
     networkType: NetworkType.connected,  // Only run with internet
     requiresBatteryNotLow: true,         // Skip when battery low
     requiresCharging: false,              // Allow on battery
   )
   ```

3. **Batch Operations**
   - Group API calls together
   - Cache results for reuse
   - Minimize database writes

### Network Optimization

1. **Smart Caching**
   ```dart
   // Cache weather data for 1 hour
   // Cache market data for 4 hours
   // Cache ML predictions for 24 hours
   ```

2. **Efficient API Usage**
   ```dart
   // Use AgentDecisionEngine.batchAnalyze() for multiple questions
   final results = await AgentDecisionEngine.batchAnalyze(
     questions: [question1, question2, question3],
     language: language,
   );
   ```

3. **Offline Capability**
   - All agents work with cached data
   - Local rule-based fallbacks when AI unavailable
   - Queue decisions for sync when online

### Memory Optimization

1. **Database Cleanup**
   ```dart
   // Runs automatically daily
   await AgentService.performMaintenance();
   ```

2. **Limit History**
   - Keep last 30 days of decisions
   - Keep last 7 days of completed tasks
   - Keep last 50 notifications

3. **Insight Expiration**
   - Low priority: 24 hours
   - Medium priority: 7 days
   - High priority: Until acknowledged

## Testing

### Unit Testing

Create test file `test/agent_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:farmsphere/services/agent_service.dart';

void main() {
  group('Agent Service Tests', () {
    test('Initialize agent service', () async {
      await AgentService.initialize();
      expect(AgentService, isNotNull);
    });

    test('Get agent statuses', () async {
      await AgentService.initialize();
      final statuses = await AgentService.getAgentStatuses();
      expect(statuses.length, equals(5)); // 5 agent types
    });

    test('Schedule agent task', () async {
      await AgentService.initialize();
      final task = AgentTask(
        id: 'test_task',
        type: AgentType.weather,
        name: 'Test Task',
        description: 'Test',
        context: {},
        scheduledTime: DateTime.now(),
        priority: AgentPriority.medium,
        status: AgentTaskStatus.pending,
        createdAt: DateTime.now(),
      );
      
      await AgentService.scheduleTask(task);
      // Verify task was scheduled
    });
  });
}
```

### Integration Testing

Test agent workflows:

```dart
void main() {
  testWidgets('Agent Dashboard loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AgentDashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify dashboard elements
    expect(find.text('AI Agents'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });
}
```

### Manual Testing Checklist

- [ ] Agents initialize without errors
- [ ] Background tasks register successfully
- [ ] Notifications appear at correct times
- [ ] Agent dashboard displays data correctly
- [ ] Toggle agents on/off works
- [ ] Insights can be dismissed
- [ ] Decisions can be acknowledged
- [ ] Settings persist across restarts
- [ ] Agents work offline with cached data
- [ ] Battery usage is acceptable
- [ ] No memory leaks during long runs

## Monitoring & Debugging

### Enable Debug Mode

```dart
// In development, agents log detailed information
if (kDebugMode) {
  // Logs are automatically enabled
}
```

### View Agent Statistics

```dart
final stats = await AgentService.getStatistics();
print('Pending tasks: ${stats['pending_tasks']}');
print('Active insights: ${stats['active_insights']}');
print('Notifications sent: ${stats['notifications_sent']}');
```

### Test Notifications

```dart
await AgentService.sendTestNotification();
```

### Monitor Background Execution

Check device logs:
```bash
# Android
adb logcat | grep "AgentService\|WeatherAgent\|WorkManager"

# iOS
Console.app (filter by app name)
```

## Troubleshooting

### Agents Not Running

1. Check if agents are enabled:
   ```dart
   final statuses = await AgentService.getAgentStatuses();
   ```

2. Verify background tasks are registered:
   ```dart
   await BackgroundTaskService.registerAgentTasks();
   ```

3. Check permissions (notifications, battery optimization)

### Notifications Not Appearing

1. Verify permissions granted
2. Check notification settings on device
3. Test with:
   ```dart
   await AgentService.sendTestNotification();
   ```

### High Battery Usage

1. Reduce check frequency in settings
2. Enable battery optimization constraints
3. Review agent logs for excessive API calls

### Memory Issues

1. Run maintenance:
   ```dart
   await AgentService.performMaintenance();
   ```

2. Check database size:
   ```bash
   # Android
   adb shell run-as com.yourapp ls -lh /data/data/com.yourapp/databases/
   ```

## Best Practices

1. **Initialize Early**: Call `AgentInit.initialize()` in `main()` before `runApp()`

2. **Handle Errors Gracefully**: Agents should never crash the app
   ```dart
   try {
     await WeatherAgent.analyze(location);
   } catch (e) {
     // Log error, continue app operation
   }
   ```

3. **Respect User Preferences**: Always check if agent is enabled before running

4. **Provide Feedback**: Show user when agents complete analysis

5. **Be Transparent**: Display reasoning behind recommendations

6. **Allow Control**: Let users enable/disable individual agents

7. **Optimize for Local Conditions**: Use location-specific thresholds

8. **Test with Real Data**: Use actual farming scenarios

## Future Enhancements

- Multi-agent collaboration (agents sharing insights)
- Learning from user feedback (improve recommendations)
- Community intelligence (learn from similar farmers)
- Voice-activated agent interactions
- IoT sensor integration (soil moisture, temperature)
- Predictive yield modeling
- Automated report generation

## Support

For issues or questions:
1. Check this documentation
2. Review example implementations
3. Enable debug mode and check logs
4. File an issue with logs and details

## License

MIT License - See LICENSE file for details
