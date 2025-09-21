import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final Map<String, dynamic> forecast;

  const ForecastCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(forecast['date']);
    final dayName = _getDayName(date.weekday);
    final high = forecast['high'];
    final low = forecast['low'];
    final condition = forecast['condition'];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}/${date.month}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              _getWeatherIcon(condition),
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              condition ?? 'Unknown',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${high}°/${low}°',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
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
}

