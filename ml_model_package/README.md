# Plant Disease Detection ML Model Package

A reusable Flutter widget that provides plant disease detection functionality using TensorFlow Lite. This package includes everything you need to integrate AI-powered plant disease detection into your Flutter application.

## Features

- 🌱 **Plant Disease Detection** - Detects 3 specific plant diseases using TensorFlow Lite
- 📱 **Mobile Optimized** - Runs entirely on-device, no internet required
- 📸 **Image Capture** - Camera and gallery integration
- 🎯 **High Accuracy** - Pre-trained model with confidence scoring
- 💊 **Treatment Recommendations** - Provides specific treatment advice for each disease
- 🎨 **Customizable UI** - Fully customizable styling and appearance
- ⚡ **Real-time Processing** - Fast image classification

## Supported Diseases

The model can detect the following plant diseases:

1. **Corn Gray Leaf Spot** (`Corn__gray_leaf_spot`)
2. **Pepper Bell Bacterial Spot** (`Pepper_bell__bacterial_spot`)
3. **Strawberry Leaf Scorch** (`Strawberry__leaf_scorch`)

## Files Included

```
ml_model_package/
├── lib/
│   └── plant_disease_detector.dart  # Main ML model widget implementation
├── assets/
│   ├── model.tflite                 # Pre-trained TensorFlow Lite model (~98MB)
│   └── classes.txt                  # Disease class labels
├── pubspec.yaml                     # Package dependencies
└── README.md                        # This documentation
```

## Quick Start

### 1. Copy Files to Your Project

Copy the following files to your Flutter project:

- `lib/plant_disease_detector.dart` → `your_project/lib/plant_disease_detector.dart`
- `assets/model.tflite` → `your_project/assets/model.tflite`
- `assets/classes.txt` → `your_project/assets/classes.txt`

### 2. Update pubspec.yaml

Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  tflite_flutter: ^0.10.1
  image_picker: ^1.2.0
  tflite_v2: ^1.0.0

flutter:
  assets:
    - assets/model.tflite
    - assets/classes.txt
```

### 3. Import and Use

```dart
import 'package:your_project/plant_disease_detector.dart';

// Basic usage
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
);

// Or with custom styling
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PlantDiseaseDetector(
      title: 'My Plant Doctor',
      backgroundColor: Colors.green.shade50,
      appBarColor: Colors.green,
      fabColor: Colors.green.shade600,
      confidenceThreshold: 0.5,
    ),
  ),
);
```

## Model Details

### **Technical Specifications:**
- **Framework:** TensorFlow Lite
- **Model Size:** ~98.8 MB
- **Input:** RGB images (any size, automatically resized)
- **Output:** Disease classification with confidence scores
- **Preprocessing:** Mean = 127.5, Std = 127.5
- **Threshold:** 0.1 (minimum confidence for detection)

### **Performance:**
- **On-device processing:** No internet required
- **Speed:** Real-time classification
- **Accuracy:** Pre-trained model optimized for mobile deployment
- **Memory:** Efficient TensorFlow Lite format

## Customization Options

The `PlantDiseaseDetector` widget supports extensive customization:

```dart
PlantDiseaseDetector(
  title: 'Custom Plant Doctor',           // App bar title
  backgroundColor: Colors.white,          // Background color
  appBarColor: Colors.blue,               // App bar color
  fabColor: Colors.blue.shade600,          // Floating action button color
  titleStyle: TextStyle(fontSize: 20),     // App bar title style
  diseaseNameStyle: TextStyle(fontSize: 24), // Disease name style
  descriptionStyle: TextStyle(fontSize: 16),  // Description text style
  confidenceStyle: TextStyle(fontSize: 14),   // Confidence text style
  confidenceThreshold: 0.3,               // Minimum confidence threshold
  showConfidence: true,                    // Show/hide confidence scores
  customTreatments: {                      // Custom treatment descriptions
    'Corn__gray_leaf_spot': 'Your custom treatment advice...',
  },
)
```

## Integration Examples

### Floating Action Button
```dart
floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
    );
  },
  child: Icon(Icons.camera_alt),
),
```

### Navigation Menu
```dart
ListTile(
  leading: Icon(Icons.camera_alt),
  title: Text('Plant Disease Detection'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
    );
  },
),
```

### Custom Button
```dart
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
    );
  },
  icon: Icon(Icons.camera_alt),
  label: Text('Detect Disease'),
),
```

## Treatment Recommendations

The model provides specific treatment advice for each detected disease:

### **Corn Gray Leaf Spot:**
"Use resistant corn hybrids, conventional tillage where appropriate, and crop rotation. Foliar fungicides can also be effective."

### **Pepper Bell Bacterial Spot:**
"Wash seeds for 40 minutes in diluted Clorox."

### **Strawberry Leaf Scorch:**
"Use of proper plant spacing to provide adequate air circulation and the use of drip irrigation."

## Error Handling

The widget includes comprehensive error handling:

- **Model loading errors:** Shows error dialog if model fails to load
- **Image capture errors:** Handles camera/gallery permission issues
- **Classification errors:** Shows user-friendly error messages
- **No detection:** Informs user when no disease is detected

## Troubleshooting

### Common Issues

1. **Model Loading Error:**
   - Ensure `model.tflite` and `classes.txt` are in the `assets` folder
   - Check that assets are properly declared in `pubspec.yaml`
   - Run `flutter clean && flutter pub get`

2. **No Detection Results:**
   - Try with clearer, well-lit images
   - Ensure the plant disease is one of the 3 supported types
   - Check that confidence threshold isn't too high

3. **Camera Permission Issues:**
   - Add camera permissions to `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <uses-permission android:name="android.permission.CAMERA" />
     ```
   - Add camera permissions to `ios/Runner/Info.plist`:
     ```xml
     <key>NSCameraUsageDescription</key>
     <string>This app needs camera access to detect plant diseases</string>
     ```

4. **Build Errors:**
   - Ensure Flutter SDK version is compatible (>=3.1.0)
   - Run `flutter pub get` after adding dependencies
   - Check that all required packages are properly installed

### Performance Tips

- **Image Quality:** Use images with good lighting and clear focus
- **Image Size:** Larger images may take longer to process
- **Model Loading:** The model loads once when the widget initializes
- **Memory:** The model is ~98MB, ensure sufficient device storage

## Dependencies

- `tflite_flutter: ^0.10.1` - TensorFlow Lite Flutter integration
- `image_picker: ^1.2.0` - Camera and gallery image selection
- `tflite_v2: ^1.0.0` - TensorFlow Lite v2 support
- `flutter` - Flutter framework

## Model Training Information

This model was trained on a dataset of plant disease images and optimized for mobile deployment using TensorFlow Lite. The model focuses on 3 specific diseases commonly affecting corn, pepper, and strawberry plants.

## License

This package is provided as-is for integration into your Flutter projects. The TensorFlow Lite model is included for educational and development purposes.

## Support

For issues related to:
- **TensorFlow Lite**: Check [TensorFlow Lite Documentation](https://www.tensorflow.org/lite)
- **Flutter Integration**: Check [Flutter Documentation](https://flutter.dev/docs)
- **Image Picker**: Check [Image Picker Package](https://pub.dev/packages/image_picker)
- **Package Issues**: Review the code and customize as needed for your specific use case
