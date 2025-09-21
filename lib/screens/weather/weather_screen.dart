import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/alert_card.dart';
import '../../widgets/forecast_card.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeatherData();
    });
  }

  Future<void> _loadWeatherData() async {
    final userState = ref.read(userProvider);
    if (userState.location != null) {
      ref.read(weatherProvider.notifier).fetchWeatherData(userState.location!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeatherData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadWeatherData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Weather
              if (weatherState.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (weatherState.error != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load weather data',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weatherState.error!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadWeatherData,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (weatherState.currentWeather != null) ...[
                WeatherCard(weather: weatherState.currentWeather!),
                const SizedBox(height: 16),
              ],

              // Weather Forecast
              if (weatherState.forecast != null && weatherState.forecast!.isNotEmpty) ...[
                Text(
                  '7-Day Forecast',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weatherState.forecast!.length,
                    itemBuilder: (context, index) {
                      final forecast = weatherState.forecast![index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < weatherState.forecast!.length - 1 ? 12 : 0,
                        ),
                        child: ForecastCard(forecast: forecast),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Weather Alerts
              if (weatherState.alerts != null && weatherState.alerts!.isNotEmpty) ...[
                Text(
                  'Weather Alerts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...weatherState.alerts!.map((alert) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AlertCard(alert: alert),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Weather Tips
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Weather Tips',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const _WeatherTip(
                        icon: Icons.water_drop,
                        title: 'Irrigation',
                        description: 'Water your crops early morning or late evening to reduce evaporation.',
                      ),
                      const _WeatherTip(
                        icon: Icons.wb_sunny,
                        title: 'Sun Protection',
                        description: 'Use shade nets during extreme heat to protect young plants.',
                      ),
                      const _WeatherTip(
                        icon: Icons.grain,
                        title: 'Rain Management',
                        description: 'Ensure proper drainage to prevent waterlogging during heavy rains.',
                      ),
                      const _WeatherTip(
                        icon: Icons.air,
                        title: 'Wind Protection',
                        description: 'Install windbreaks to protect crops from strong winds.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherTip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _WeatherTip({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

