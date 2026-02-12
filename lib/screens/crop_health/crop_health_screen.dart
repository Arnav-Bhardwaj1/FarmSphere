import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/app_providers.dart';
import '../../widgets/diagnosis_result_card.dart';
import '../../widgets/loading_overlay.dart';
import '../../plant_disease_detector.dart';

class CropHealthScreen extends ConsumerStatefulWidget {
  const CropHealthScreen({super.key});

  @override
  ConsumerState<CropHealthScreen> createState() => _CropHealthScreenState();
}

class _CropHealthScreenState extends ConsumerState<CropHealthScreen> {
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isAnalyzing = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Check camera permission
    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission is required to scan crops'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
    } else if (cameraStatus.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog();
      }
      return;
    }
    
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'FarmSphere needs camera access to scan and diagnose crop diseases. '
          'Please enable camera permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _analyzeCrop() async {
    if (_selectedImage == null && _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseProvideImageOrDescription),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      await ref.read(cropHealthProvider.notifier).analyzeCropHealth(
        _selectedImage?.path ?? '',
        _descriptionController.text.trim(),
      );
    } catch (e) {
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.analysisFailed(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropHealthState = ref.watch(cropHealthProvider);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.aiCropHealthScanner),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showDiagnosisHistory();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              t.howToUse,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.cropHealthInstructions,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Image Selection
                Text(
                  t.uploadImage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                
                if (_selectedImage != null) ...[
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb 
                          ? Image.network(
                              _selectedImage!.path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                        Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera_alt),
                          label: Text(t.retake),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickImageFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: Text(t.gallery),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        icon: const Icon(Icons.delete),
                        label: Text(t.remove),
                      ),
                    ],
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.noImageSelected,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.camera_alt),
                              label: Text(t.takePhoto),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _pickImageFromGallery,
                              icon: const Icon(Icons.photo_library),
                              label: Text(t.gallery),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // Description Input
                Text(
                  t.orDescribeSymptoms,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: t.describeSymptomsHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // ML Disease Detection Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlantDiseaseDetector(
                            title: 'AI Plant Disease Scanner',
                            backgroundColor: Color(0xFFF8F9FA),
                            appBarColor: Color(0xFF36946F),
                            fabColor: Color(0xFF2D3648),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.smart_toy),
                    label: Text(t.aiDiseaseDetection),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF36946F),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Analyze Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeCrop,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.analytics),
                    label: Text(_isAnalyzing ? t.analyzing : t.analyzeCropHealth),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Results
                if (cropHealthState.lastDiagnosis != null) ...[
                  Text(
                    t.analysisResult,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DiagnosisResultCard(diagnosis: cropHealthState.lastDiagnosis!),
                ],
                
                const SizedBox(height: 24),
                
                // Diagnosis History
                if (cropHealthState.diagnosisHistory != null && cropHealthState.diagnosisHistory!.isNotEmpty) ...[
                  Text(
                    t.recentDiagnoses,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...cropHealthState.diagnosisHistory!.take(3).map((diagnosis) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DiagnosisResultCard(
                        diagnosis: diagnosis,
                        isCompact: true,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (_isAnalyzing)
            LoadingOverlay(
              message: AppLocalizations.of(context)!.analyzingCropHealth,
            ),
        ],
      ),
    );
  }

  void _showDiagnosisHistory() {
    final cropHealthState = ref.read(cropHealthProvider);
    
    final t = AppLocalizations.of(context)!;
    if (cropHealthState.diagnosisHistory == null || cropHealthState.diagnosisHistory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.noDiagnosisHistory),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.diagnosisHistory,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: cropHealthState.diagnosisHistory!.length,
                  itemBuilder: (context, index) {
                    final diagnosis = cropHealthState.diagnosisHistory![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DiagnosisResultCard(
                        diagnosis: diagnosis,
                        showTimestamp: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

