import 'package:flutter/material.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import '../utils/localization_helpers.dart';

class PriceCard extends StatelessWidget {
  final Map<String, dynamic> price;

  const PriceCard({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final crop = price['crop'] ?? 'Unknown';
    final priceValue = price['price'] ?? price['mspPrice'] ?? 0;
    final unit = price['unit'] ?? '';
    final market = price['market'] ?? 'Unknown Market';
    final state = price['state'] ?? '';
    final season = price['season'] ?? '';
    final category = price['category'] ?? '';
    final isMSP = price['mspPrice'] != null;
    final variety = price['variety'] ?? '';
    final arrival = price['arrival'] ?? '';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Crop Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isMSP 
                        ? Colors.green.withOpacity(0.1)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCropIcon(crop),
                    color: isMSP 
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Crop Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            LocalizationHelpers.getLocalizedCropName(t, crop),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isMSP) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'MSP',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isMSP ? t.governmentMSP : market,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (state.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          state,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${priceValue.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isMSP 
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      unit,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // Additional details
            if (season.isNotEmpty || category.isNotEmpty || variety.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (season.isNotEmpty)
                    _buildDetailChip(context, t.labelSeason, LocalizationHelpers.getLocalizedSeason(t, season), Icons.calendar_today),
                  if (category.isNotEmpty)
                    _buildDetailChip(context, t.labelCategory, LocalizationHelpers.getLocalizedCategory(t, category), Icons.category),
                  if (variety.isNotEmpty)
                    _buildDetailChip(context, t.labelVariety, variety, Icons.local_florist),
                ],
              ),
            ],
            
            // Arrival date for market prices
            if (arrival.isNotEmpty && !isMSP) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${t.labelArrival}: ${_formatDate(arrival)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 11,
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

  Widget _buildDetailChip(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  IconData _getCropIcon(String crop) {
    switch (crop.toLowerCase()) {
      case 'rice':
        return Icons.grain;
      case 'wheat':
        return Icons.eco;
      case 'tomato':
        return Icons.local_pizza;
      case 'potato':
        return Icons.circle;
      case 'onion':
        return Icons.circle_outlined;
      case 'corn':
        return Icons.grass;
      case 'cotton':
        return Icons.agriculture;
      default:
        return Icons.eco;
    }
  }
}

