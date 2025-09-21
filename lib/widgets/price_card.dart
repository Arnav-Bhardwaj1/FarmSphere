import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  final Map<String, dynamic> price;

  const PriceCard({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final crop = price['crop'] ?? 'Unknown';
    final priceValue = price['price'] ?? 0;
    final unit = price['unit'] ?? '';
    final market = price['market'] ?? 'Unknown Market';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Crop Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCropIcon(crop),
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Crop Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    market,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
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
                    color: Theme.of(context).colorScheme.primary,
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
      ),
    );
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

