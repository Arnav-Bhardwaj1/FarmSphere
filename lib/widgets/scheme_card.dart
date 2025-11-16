import 'package:flutter/material.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/localization_helpers.dart';

class SchemeCard extends StatelessWidget {
  final Map<String, dynamic> scheme;

  const SchemeCard({
    super.key,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final title = scheme['title'] ?? 'Unknown Scheme';
    final description = scheme['description'] ?? '';
    final eligibility = scheme['eligibility'] ?? '';
    final status = LocalizationHelpers.getLocalizedStatus(t, scheme['status'] ?? 'Unknown');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _getStatusColor(status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          status,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            if (eligibility.isNotEmpty) ...[
              const SizedBox(height: 12),
              
              // Eligibility
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.green[600],
                  ),
                  const SizedBox(width: 8),
                      Expanded(
                    child: Text(
                      '${t.eligibility}: $eligibility',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showSchemeDetails(context, scheme);
                },
                icon: const Icon(Icons.info_outline),
                label: Text(t.learnMore),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'upcoming':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showSchemeDetails(BuildContext context, Map<String, dynamic> scheme) {
    showDialog(
      context: context,
      builder: (context) {
        final t = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(scheme['title'] ?? t.schemeDetails),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (scheme['description'] != null) ...[
                Text(
                  t.description,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(scheme['description']),
                const SizedBox(height: 12),
              ],
              if (scheme['eligibility'] != null) ...[
                Text(
                  t.eligibility,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(scheme['eligibility']),
                const SizedBox(height: 12),
              ],
              if (scheme['benefit'] != null) ...[
                Text(
                  t.benefits,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(scheme['benefit']),
                const SizedBox(height: 12),
              ],
              if (scheme['applicationProcess'] != null) ...[
                Text(
                  t.howToApply,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(scheme['applicationProcess']),
                const SizedBox(height: 12),
              ],
              if (scheme['website'] != null) ...[
                Text(
                  t.officialWebsite,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => _launchURL(scheme['website']),
                  child: Text(
                    scheme['website'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (scheme['status'] != null) ...[
                Text(
                  t.status,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(LocalizationHelpers.getLocalizedStatus(t, scheme['status'])),
              ],
            ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.close),
            ),
            if (scheme['website'] != null)
              ElevatedButton.icon(
                onPressed: () => _launchURL(scheme['website']),
                icon: const Icon(Icons.open_in_new),
                label: Text(t.visitWebsite),
              ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

