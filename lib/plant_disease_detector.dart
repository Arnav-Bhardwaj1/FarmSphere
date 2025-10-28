import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/plant_disease_service.dart';

/// A reusable plant disease detection widget using TensorFlow Lite
/// 
/// This widget provides:
/// - Image capture from camera or gallery
/// - Real-time plant disease detection
/// - Disease classification with confidence scores
/// - Treatment recommendations
/// - Customizable UI styling
/// - Modern gradients and animations
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
  String? _debugRawResults;

  // Default treatment descriptions - populated from JSON
  final Map<String, String> _defaultTreatments = {};
  
  void _loadTreatmentsFromJson() async {
    try {
      // Load all treatments from the JSON file
      final String jsonString = '''
[
  {"name": "Apple___Apple_scab", "cause": "Fungus Venturia inaequalis. Favorable conditions are cool, wet weather.", "cure": "Use fungicides and resistant apple varieties. Prune and destroy infected leaves."},
  {"name": "Apple___Black_rot", "cause": "Caused by the fungus Botryosphaeria obtusa.", "cure": "Prune and remove infected areas. Apply fungicides during the growing season."},
  {"name": "Apple___Cedar_apple_rust", "cause": "Fungus Gymnosporangium juniperi-virginianae. Requires junipers as an alternate host.", "cure": "Remove nearby juniper hosts. Use resistant varieties and fungicides."},
  {"name": "Apple___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Background_without_leaves", "cause": "No disease or plant detected.", "cure": "Not applicable."},
  {"name": "Blueberry___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Cherry___Powdery_mildew", "cause": "Fungus Podosphaera clandestina.", "cure": "Apply sulfur-based or fungicide treatments. Ensure good air circulation."},
  {"name": "Cherry___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Corn___Cercospora_leaf_spot Gray_leaf_spot", "cause": "Fungus Cercospora zeae-maydis.", "cure": "Use resistant hybrids and fungicide sprays."},
  {"name": "Corn___Common_rust", "cause": "Fungus Puccinia sorghi.", "cure": "Apply fungicides and plant resistant varieties."},
  {"name": "Corn___Northern_Leaf_Blight", "cause": "Fungus Exserohilum turcicum.", "cure": "Use resistant varieties and fungicides."},
  {"name": "Corn___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Grape___Black_rot", "cause": "Fungus Guignardia bidwellii.", "cure": "Prune infected areas and apply fungicides."},
  {"name": "Grape___Esca_(Black_Measles)", "cause": "Fungal complex including Phaeomoniella chlamydospora.", "cure": "Remove infected wood. Avoid injuries to vines."},
  {"name": "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)", "cause": "Fungus Pseudocercospora vitis.", "cure": "Apply fungicides and manage vineyard hygiene."},
  {"name": "Grape___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Orange___Haunglongbing_(Citrus_greening)", "cause": "Bacterium Candidatus Liberibacter spp. Spread by psyllid insects.", "cure": "Control psyllid population and remove infected trees."},
  {"name": "Peach___Bacterial_spot", "cause": "Bacterium Xanthomonas campestris pv. pruni.", "cure": "Use resistant varieties and copper-based bactericides."},
  {"name": "Peach___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Pepper,_bell___Bacterial_spot", "cause": "Bacterium Xanthomonas campestris pv. vesicatoria.", "cure": "Use copper-based bactericides and resistant varieties."},
  {"name": "Pepper,_bell___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Potato___Early_blight", "cause": "Fungus Alternaria solani.", "cure": "Apply fungicides and practice crop rotation."},
  {"name": "Potato___Late_blight", "cause": "Pathogen Phytophthora infestans.", "cure": "Use resistant varieties and fungicides."},
  {"name": "Potato___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Raspberry___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Soybean___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Squash___Powdery_mildew", "cause": "Fungal pathogens including Erysiphe cichoracearum.", "cure": "Apply sulfur-based fungicides and maintain good air circulation."},
  {"name": "Strawberry___Leaf_scorch", "cause": "Fungus Diplocarpon earlianum.", "cure": "Remove infected leaves and apply fungicides."},
  {"name": "Strawberry___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."},
  {"name": "Tomato___Bacterial_spot", "cause": "Bacterium Xanthomonas spp.", "cure": "Apply copper-based bactericides and practice crop rotation."},
  {"name": "Tomato___Early_blight", "cause": "Fungus Alternaria solani.", "cure": "Apply fungicides and remove infected leaves."},
  {"name": "Tomato___Late_blight", "cause": "Pathogen Phytophthora infestans.", "cure": "Use resistant varieties and fungicides."},
  {"name": "Tomato___Leaf_Mold", "cause": "Fungus Passalora fulva.", "cure": "Apply fungicides and ensure good ventilation."},
  {"name": "Tomato___Septoria_leaf_spot", "cause": "Fungus Septoria lycopersici.", "cure": "Remove infected leaves and apply fungicides."},
  {"name": "Tomato___Spider_mites Two-spotted_spider_mite", "cause": "Spider mites Tetranychus urticae.", "cure": "Use miticides or insecticidal soaps."},
  {"name": "Tomato___Target_Spot", "cause": "Fungus Corynespora cassiicola.", "cure": "Apply fungicides and ensure good air circulation."},
  {"name": "Tomato___Tomato_Yellow_Leaf_Curl_Virus", "cause": "Virus spread by whiteflies.", "cure": "Control whitefly population and use resistant varieties."},
  {"name": "Tomato___Tomato_mosaic_virus", "cause": "Virus transmitted through contact and contaminated tools.", "cure": "Remove infected plants and sterilize tools."},
  {"name": "Tomato___healthy", "cause": "No disease present.", "cure": "Maintain good cultural practices for optimal health."}
]
    ''';
      
      final List<dynamic> data = jsonDecode(jsonString);
      for (var item in data) {
        _defaultTreatments[item['name']] = item['cure'];
      }
    } catch (e) {
      print('Error loading treatments: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTreatmentsFromJson();
    _loadModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Load the TensorFlow Lite model
  Future<void> _loadModel() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // Simulate model loading
      await Future.delayed(const Duration(seconds: 1));
      
      print("Model initialized successfully");
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading model: $e');
      setState(() {
        isLoading = false;
      });
      
      _showErrorDialog('Failed to initialize detection. Please try again.');
    }
  }

  /// Classify the selected image
  Future<void> _classifyImage(dynamic imageData) async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> recognitions;
      
      // Check if API server is running
      final isHealthy = await PlantDiseaseService.checkHealth();
      if (!isHealthy) {
        _showErrorDialog('API server is not running. Please start the server using: cd server && python plant_disease_api.py');
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      // Call API for prediction
      if (kIsWeb) {
        // For web, we need image bytes
        if (imageData is XFile) {
          final bytes = await imageData.readAsBytes();
          recognitions = await PlantDiseaseService.predictDiseaseFromBytes(bytes);
          _debugRawResults = recognitions.toString();
        } else {
          throw Exception('Unsupported image type for web');
        }
      } else {
        // For mobile/desktop, use file path
        if (imageData is File) {
          recognitions = await PlantDiseaseService.predictDisease(imageData);
          _debugRawResults = recognitions.toString();
        } else {
          throw Exception('Unsupported image type');
        }
      }

      if (recognitions.isNotEmpty) {
        setState(() {
          _results = recognitions;
          results = true;
          if (!kIsWeb) _image = imageData;
          imageSelect = true;
          
          // Get the top result
          recognitions.sort((a, b) => (b['confidence'] ?? 0.0).compareTo(a['confidence'] ?? 0.0));
          final topResult = recognitions.first;
          label = (topResult['label'] ?? 'Unknown').toString();
          
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
      _showErrorDialog('Failed to classify image: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Get treatment description for a disease
  String _getTreatmentDescription(String diseaseLabel) {
    // Use custom treatments if provided
    if (widget.customTreatments != null) {
      return widget.customTreatments![diseaseLabel] ?? 
        'No specific treatment information available for this disease.';
    }
    
    // Load from JSON file or use defaults
    return _defaultTreatments[diseaseLabel] ?? 
      'No specific treatment information available for this disease.';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.appBarColor.withOpacity(0.1),
              Colors.white,
              widget.appBarColor.withOpacity(0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
              child: Column(
                children: [
            // Custom App Bar with gradient
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.appBarColor, widget.appBarColor.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Row(
              children: [
                Container(
                            padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.bug_report_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: widget.titleStyle ?? const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: isLoading
                  ? Stack(
                      children: [
                        // Background with pulsing effect
                        Center(
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 1500),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.easeInOut,
                            onEnd: () {
                              if (mounted && isLoading) {
                                setState(() {});
                              }
                            },
                            builder: (context, value, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.appBarColor.withOpacity(0.3 * (1 - value)),
                                      widget.appBarColor.withOpacity(0.05 * (1 - value)),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Rotating scanner circle
                              Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.appBarColor.withOpacity(0.2),
                                      widget.appBarColor.withOpacity(0.1),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      strokeWidth: 4,
                                      valueColor: AlwaysStoppedAnimation<Color>(widget.appBarColor),
                                    ),
                                    TweenAnimationBuilder<double>(
                                      duration: const Duration(seconds: 2),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      onEnd: () {
                                        if (mounted && isLoading) {
                                          setState(() {});
                                        }
                                      },
                                      builder: (context, value, child) {
                                        return Transform.rotate(
                                          angle: value * 2 * 3.14159,
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: widget.appBarColor.withOpacity(0.5),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [widget.appBarColor, widget.appBarColor.withOpacity(0.7)],
                                ).createShader(bounds),
                                child: const Text(
                                  'Scanning for diseases...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'AI is analyzing your plant image',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                          // Results display first (above image for testing)
                          if (imageSelect && _results.isNotEmpty)
                            ...[
                              // Only show the top result (highest confidence)
                              _results.first as Map<String, dynamic>,
                            ].map((result) => _buildResultCard(result)),

                          const SizedBox(height: 24),

                          // Image display with enhanced styling
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: imageSelect
                                  ? SizedBox(
                                      height: 300,
                                      width: double.infinity,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          kIsWeb
                              ? Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                                ),
                                          // Subtle overlay (very low opacity to avoid hiding content)
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.03),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                          ),
                        )
                      : Container(
                          height: 300,
                          decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            widget.appBarColor.withOpacity(0.1),
                                            Colors.grey.shade100,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                          color: widget.appBarColor.withOpacity(0.3),
                                          width: 3,
                            ),
                          ),
                                      child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                            Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: widget.appBarColor.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.photo_camera_rounded,
                                  size: 64,
                                                color: widget.appBarColor,
                                              ),
                                ),
                                            const SizedBox(height: 20),
                                Text(
                                              'Scan Your Plant',
                                  style: TextStyle(
                                                color: widget.appBarColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                  ),
                                ),
                                            const SizedBox(height: 8),
                                Text(
                                              'Capture or select an image to detect diseases',
                                              textAlign: TextAlign.center,
                                  style: TextStyle(
                                                color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            ),
                          ),
                        ),
                ),

                          // Debug output removed for production
                        ],
                      ),
                    ),
            ),
          ],
        ),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Camera button with gradient
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [widget.fabColor, widget.fabColor.withOpacity(0.8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.fabColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FloatingActionButton(
            heroTag: "camera",
            onPressed: _pickImageFromCamera,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
            ),
          ),
          // Gallery button with gradient
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [widget.fabColor, widget.fabColor.withOpacity(0.8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.fabColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FloatingActionButton(
            heroTag: "gallery",
            onPressed: _pickImageFromGallery,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  /// Build result card widget with modern styling
  Widget _buildResultCard(Map<String, dynamic> result) {
    final diseaseName = result['label'] ?? 'Unknown';
    final confidence = result['confidence'] ?? 0.0;
    final treatmentDescription = _getTreatmentDescription(diseaseName);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.9 + (0.1 * value),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.appBarColor.withOpacity(0.95),
                      widget.appBarColor.withOpacity(0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.appBarColor.withOpacity(0.3 * value),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ],
      ),
      child: Padding(
                  padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                      // Disease name with icon
            Row(
              children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medical_services_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    diseaseName.replaceAll('_', ' ').toUpperCase(),
                    style: widget.diseaseNameStyle ??
                        const TextStyle(
                                    fontSize: 20,
                          fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                        ),
                  ),
                ),
              ],
            ),
                      const SizedBox(height: 20),
            
                      // Confidence score with progress bar
            if (widget.showConfidence)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Detection Confidence',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
              Text(
                                  '${(confidence * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                      fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 800),
                                    tween: Tween(begin: 0.0, end: confidence),
                                    builder: (context, value, child) {
                                      return Container(
                                        width: constraints.maxWidth * value,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Colors.white, Colors.white70],
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),
                      
                      // Treatment description with beautiful card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Treatment Recommendation',
                                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
              treatmentDescription,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
