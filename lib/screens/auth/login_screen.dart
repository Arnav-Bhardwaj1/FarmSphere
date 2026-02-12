import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import '../main_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/location_service.dart';
import '../../services/nokia_number_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;
  bool _isDetectingLocation = false;
  bool _isVerifyingNumber = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhoneNumber() async {
    final raw = _phoneController.text.trim();
    if (raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter phone number to verify')),
      );
      return;
    }

    // Ensure E.164 format when possible; prepend '+' if missing
    final phone = raw.startsWith('+') ? raw : '+$raw';

    // Nokia sandbox accepts only test device IDs: +999999201000..+999999201005
    final isSandboxAccepted = phone.startsWith('+99999920100');
    if (!isSandboxAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sandbox accepts only +999999201000..+999999201005'),
          backgroundColor: Colors.orange,
        ),
      );
      // Continue anyway so user can see the exact API response, but warn first.
    }

    setState(() => _isVerifyingNumber = true);
    try {
      final res = await NokiaNumberService.phoneNumberVerify(
        phoneNumber: phone,
        authorizationToken: '', // TODO: supply bearer token after operator consent
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification request sent for $phone'),
          backgroundColor: Colors.green,
        ),
      );
      if (kDebugMode) {
        // ignore: avoid_print
        print('Number verify response: $res');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Number verification failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isVerifyingNumber = false);
    }
  }

  Future<void> _detectLocation() async {
    setState(() {
      _isDetectingLocation = true;
    });

    try {
      // Request location permission
      final permission = await Permission.location.request();
      
      if (permission.isGranted) {
        // Get current location using Nokia Location Service
        // For testing, try simple GPS first, then Nokia API
        Map<String, dynamic> locationData;
        try {
          locationData = await LocationService.getSimpleLocation();
        } catch (e) {
          // If simple GPS fails, try Nokia API
          locationData = await LocationService.detectLocationWithNokia();
        }
        
        if (mounted) {
          _locationController.text = locationData['location'] ?? 'Unknown Location';
          
          // Show enhanced success message with accuracy info
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location detected: ${locationData['location']}'),
                  if (locationData['accuracy'] == 'Nokia Network as Code')
                    Text(
                      '✓ Enhanced accuracy via Nokia Network as Code',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[100],
                      ),
                    ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          throw Exception('Unable to detect location');
        }
      } else {
        throw Exception('Location permission denied');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location detection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDetectingLocation = false;
        });
      }
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await ref.read(userProvider.notifier).login(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _phoneController.text.trim(),
          _locationController.text.trim(),
        );

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainNavigation()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo and Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.agriculture,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        t.welcomeTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.welcomeSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Form Fields
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: t.fullName,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: t.email,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.emailRequired;
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return t.emailInvalid;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: t.phoneNumber,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.phoneRequired;
                    }
                    if (value.length < 10) {
                      return t.phoneTooShort;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Location Field with Auto-detect Button
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: t.location,
                          prefixIcon: const Icon(Icons.location_on),
                          hintText: t.locationHint,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.locationRequired;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _isDetectingLocation ? null : _detectLocation,
                      icon: _isDetectingLocation
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: Text(t.detect),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          t.getStarted,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                
                const SizedBox(height: 24),

                // Verify phone number via Nokia API
                OutlinedButton.icon(
                  onPressed: _isVerifyingNumber ? null : _verifyPhoneNumber,
                  icon: _isVerifyingNumber
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.verified_user),
                  label: Text(t.verifyPhoneNumber),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),

                const SizedBox(height: 24),
                
                // Features Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey[800] 
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey[600]! 
                          : Colors.grey[200]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.featuresHeading,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.white 
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _FeatureItem(
                        icon: Icons.camera_alt,
                        text: t.feature_ai_scanner,
                      ),
                      _FeatureItem(
                        icon: Icons.wb_sunny,
                        text: t.feature_weather,
                      ),
                      _FeatureItem(
                        icon: Icons.trending_up,
                        text: t.feature_market,
                      ),
                      _FeatureItem(
                        icon: Icons.record_voice_over,
                        text: t.feature_voice_local,
                      ),
                      _FeatureItem(
                        icon: Icons.analytics,
                        text: t.feature_activity,
                      ),
                      _FeatureItem(
                        icon: Icons.people,
                        text: t.feature_community,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white70 
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

