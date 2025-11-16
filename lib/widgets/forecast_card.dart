import 'package:flutter/material.dart';
import 'package:farmsphere/l10n/app_localizations.dart';

class ForecastCard extends StatelessWidget {
  final Map<String, dynamic> forecast;

  const ForecastCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(forecast['date']);
    final dayName = _getDayName(context, date.weekday);
    final high = forecast['high'];
    final low = forecast['low'];
    final condition = forecast['condition'];
    final humidity = forecast['humidity'];
    final precipitation = forecast['precipitation'];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 90,
        height: 110,
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${date.day}/${date.month}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 9,
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              _getWeatherIcon(condition),
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 3),
            Text(
              _localizeCondition(context, condition),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '$high°/$low°',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 9,
              ),
            ),
            if (humidity != null) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 8,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 1),
                  Text(
                    '$humidity%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 7,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
            if (precipitation != null && precipitation > 0) ...[
              const SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.grain,
                    size: 8,
                    color: Colors.blue[600],
                  ),
                  const SizedBox(width: 1),
                  Text(
                    '${(precipitation * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 7,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDayName(BuildContext context, int weekday) {
    final t = AppLocalizations.of(context)!;
    switch (weekday) {
      case 1:
        return t.dayMon;
      case 2:
        return t.dayTue;
      case 3:
        return t.dayWed;
      case 4:
        return t.dayThu;
      case 5:
        return t.dayFri;
      case 6:
        return t.daySat;
      case 7:
        return t.daySun;
      default:
        return '';
    }
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
      default:
        return value.isEmpty ? t.conditionUnknown : value;
    }
  }
}

