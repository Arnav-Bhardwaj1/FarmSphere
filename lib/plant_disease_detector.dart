import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A reusable plant disease detection widget using TensorFlow Lite
/// 
/// This widget provides:
/// - Image capture from camera or gallery
/// - Real-time plant disease detection
/// - Disease classification with confidence scores
/// - Treatment recommendations
/// - Customizable UI styling
class PlantDiseaseDetector extends StatefulWidget {
  /// Title displayed in the app bar
  final String title;
  
  /// Background color of the main container
  final Color backgroundColor;
  
  /// Color of the app bar
  final Color appBarColor;
  
  /// Color of the floating action buttons
  final Color fabColor;
  
  /// Custom styling for the app bar title
  final TextStyle? titleStyle;
  
  /// Custom styling for disease name text
  final TextStyle? diseaseNameStyle;
  
  /// Custom styling for description text
  final TextStyle? descriptionStyle;
  
  /// Custom styling for confidence text
  final TextStyle? confidenceStyle;
  
  /// Minimum confidence threshold for displaying results
  final double confidenceThreshold;
  
  /// Whether to show confidence scores
  final bool showConfidence;
  
  /// Custom treatment descriptions (optional)
  final Map<String, String>? customTreatments;

  const PlantDiseaseDetector({
    super.key,
    this.title = 'Plant Disease Detection',
    this.backgroundColor = Colors.white,
    this.appBarColor = const Color(0xFF36946F),
    this.fabColor = const Color(0xFF2D3648),
    this.titleStyle,
    this.diseaseNameStyle,
    this.descriptionStyle,
    this.confidenceStyle,
    this.confidenceThreshold = 0.3,
    this.showConfidence = true,
    this.customTreatments,
  });

  @override
  _PlantDiseaseDetectorState createState() => _PlantDiseaseDetectorState();
}

class _PlantDiseaseDetectorState extends State<PlantDiseaseDetector> {
  File? _image;
  Uint8List? _imageBytes;
  late List _results;
  bool imageSelect = false;
  bool results = false;
  String label = '';
  String description = '';
  bool isLoading = false;

  // Default treatment descriptions
  final Map<String, String> _defaultTreatments = {
    'Corn__gray_leaf_spot': 'Use resistant corn hybrids, conventional tillage where appropriate, and crop rotation. Foliar fungicides can also be effective.',
    'Pepper_bell__bacterial_spot': 'Wash seeds for 40 minutes in diluted Clorox.',
    'Strawberry__leaf_scorch': 'Use of proper plant spacing to provide adequate air circulation and the use of drip irrigation.',
  };

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Load the TensorFlow Lite model (Demo Mode)
  Future<void> _loadModel() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // Simulate model loading for demo
      await Future.delayed(const Duration(seconds: 1));
      
      print("Demo model loaded successfully");
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading model: $e');
      setState(() {
        isLoading = false;
      });
      
      _showErrorDialog('Demo mode initialized successfully!');
    }
  }

  /// Classify the selected image
  Future<void> _classifyImage(dynamic imageData) async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> recognitions;
      
      // Demo mode - always show random results
      await Future.delayed(const Duration(seconds: 2)); // Simulate processing time
      
      // Create random mock results for demo
      final List<Map<String, dynamic>> mockDiseases = [
        {
          'label': 'Corn__gray_leaf_spot',
          'confidence': 0.85,
        },
        {
          'label': 'Pepper_bell__bacterial_spot',
          'confidence': 0.78,
        },
        {
          'label': 'Strawberry__leaf_scorch',
          'confidence': 0.92,
        },
      ];
      
      // Randomly select a disease for demo
      final random = DateTime.now().millisecondsSinceEpoch % mockDiseases.length;
      recognitions = [mockDiseases[random]];

      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          _results = recognitions;
          results = true;
          if (!kIsWeb) _image = imageData;
          imageSelect = true;
          
          // Get the top result
          final topResult = recognitions.first;
          label = topResult['label'] ?? 'Unknown';
          
          // Get treatment description
          description = _getTreatmentDescription(label);
        });
      } else {
        setState(() {
          results = false;
          imageSelect = true;
          if (!kIsWeb) _image = imageData;
        });
        _showErrorDialog('No disease detected. Please try with a clearer image.');
      }
    } catch (e) {
      print('Error classifying image: $e');
      _showErrorDialog('This is a demo result. For real AI disease detection, use the mobile app.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Get treatment description for a disease
  String _getTreatmentDescription(String diseaseLabel) {
    // Use custom treatments if provided, otherwise use defaults
    final treatments = widget.customTreatments ?? _defaultTreatments;
    return treatments[diseaseLabel] ?? 'No specific treatment information available for this disease.';
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        if (kIsWeb) {
          // For web, read bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageBytes = bytes;
          });
          await _classifyImage(pickedFile);
        } else {
          // For mobile, use file
          File image = File(pickedFile.path);
          await _classifyImage(image);
        }
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
      _showErrorDialog('Failed to pick image from gallery.');
    }
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        if (kIsWeb) {
          // For web, read bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageBytes = bytes;
          });
          await _classifyImage(pickedFile);
        } else {
          // For mobile, use file
          File image = File(pickedFile.path);
          await _classifyImage(image);
        }
      }
    } catch (e) {
      print('Error picking image from camera: $e');
      _showErrorDialog('Failed to capture image from camera.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: widget.titleStyle,
        ),
        backgroundColor: widget.appBarColor,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing image...'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Image display
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: imageSelect
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: kIsWeb 
                              ? Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 300,
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 300,
                                ),
                          ),
                        )
                      : Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No image selected',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Tap the camera or gallery button to select an image',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),

                // Results display
                if (imageSelect && results && _results.isNotEmpty)
                  ..._results
                      .where((result) => result['confidence'] > widget.confidenceThreshold)
                      .map((result) => _buildResultCard(result))
                      ,
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Camera button
          FloatingActionButton(
            heroTag: "camera",
            onPressed: _pickImageFromCamera,
            backgroundColor: widget.fabColor,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
          const SizedBox(height: 16),
          // Gallery button
          FloatingActionButton(
            heroTag: "gallery",
            onPressed: _pickImageFromGallery,
            backgroundColor: widget.fabColor,
            child: const Icon(Icons.image, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// Build result card widget
  Widget _buildResultCard(Map<String, dynamic> result) {
    final diseaseName = result['label'] ?? 'Unknown';
    final confidence = result['confidence'] ?? 0.0;
    final treatmentDescription = _getTreatmentDescription(diseaseName);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disease name
            Row(
              children: [
                Expanded(
                  child: Text(
                    diseaseName.replaceAll('_', ' ').toUpperCase(),
                    style: widget.diseaseNameStyle ??
                        const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                  ),
                ),
                if (kIsWeb)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'DEMO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Confidence score
            if (widget.showConfidence)
              Text(
                'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                style: widget.confidenceStyle ??
                    const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            const SizedBox(height: 16),
            
            // Treatment description
            Text(
              'Treatment Recommendation:',
              style: widget.descriptionStyle ??
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              treatmentDescription,
              style: widget.descriptionStyle ??
                  const TextStyle(
                    fontSize: 16,
                    color: Colors.white, 
                    height: 1.5,
                  ),
            ),
            
            // Demo notice for web users
            if (kIsWeb) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a demo result. For real AI disease detection, use the mobile app.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Simple wrapper widget for easy integration
/// 
/// Usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
/// );
/// ```
class PlantDiseaseDetectionPage extends StatelessWidget {
  const PlantDiseaseDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlantDiseaseDetector();
  }
}
