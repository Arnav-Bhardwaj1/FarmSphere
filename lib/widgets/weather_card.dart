import 'package:flutter/material.dart';
import 'package:farmsphere/l10n/app_localizations.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F172A), // Very dark blue-gray
              Color(0xFF1E293B), // Dark slate
              Color(0xFF334155), // Slate gray
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.6, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with location and weather icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.currentWeatherTitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      (weather['location'] as String?) ?? AppLocalizations.of(context)!.yourLocation,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    if (weather['country'] != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        // Note: City and country names are proper nouns and typically 
                        // remain in their original language. The API returns English names.
                        (weather['country'] as String?) ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getWeatherIcon(weather['condition'] as String?),
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Main temperature display - centered
            Center(
              child: Column(
                children: [
                  Text(
                    '${(weather['temperature'] as num?)?.round() ?? 0}°',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                      fontSize: 56,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _localizeCondition(context, weather['condition'] as String?),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (weather['description'] != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      (weather['description'] as String?) ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Weather details grid - better organized
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // First row
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeatherDetailCard(
                          context,
                          Icons.water_drop,
                          AppLocalizations.of(context)!.humidityLabel,
                          '${(weather['humidity'] as num?)?.round() ?? 0}%',
                          Colors.blue[300]!,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildWeatherDetailCard(
                          context,
                          Icons.air,
                          AppLocalizations.of(context)!.windLabel,
                          '${(weather['windSpeed'] as num?)?.round() ?? 0} km/h',
                          Colors.green[300]!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Second row
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeatherDetailCard(
                          context,
                          Icons.visibility,
                          AppLocalizations.of(context)!.visibilityLabel,
                          '${(weather['visibility'] as num?)?.round() ?? 0} km',
                          Colors.purple[300]!,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildWeatherDetailCard(
                          context,
                          Icons.wb_sunny,
                          AppLocalizations.of(context)!.uvIndexLabel,
                          '${(weather['uvIndex'] as num?)?.round() ?? 0}',
                          Colors.yellow[300]!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailCard(BuildContext context, IconData icon, String label, String value, Color iconColor, {bool isWide = false}) {
    return Container(
      width: isWide ? 180 : null,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.wb_sunny;
    
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'partly cloudy':
        return Icons.wb_cloudy;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.grain;
      case 'stormy':
        return Icons.thunderstorm;
      default:
        return Icons.wb_sunny;
    }
  }

  String _localizeCondition(BuildContext context, String? condition) {
    final t = AppLocalizations.of(context)!;
    final value = (condition ?? '').toString();
    switch (value.toLowerCase()) {
      case 'sunny':
        return t.conditionSunny;
      case 'partly cloudy':
        return t.conditionPartlyCloudy;
      case 'cloudy':
        return t.conditionCloudy;
      case 'rainy':
        return t.conditionRainy;
      case 'stormy':
        return t.conditionStormy;
      case 'haze':
        return t.conditionHaze;
      case 'fog':
        return t.conditionFog;
      case 'mist':
        return t.conditionMist;
      default:
        return value.isEmpty ? t.conditionUnknown : value;
    }
  }
}

