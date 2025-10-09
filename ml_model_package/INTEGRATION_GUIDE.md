# Quick Integration Guide - Plant Disease Detection

## Step-by-Step Integration

### 1. Copy Required Files

Copy these files from `ml_model_package/` to your Flutter project:

```
ml_model_package/lib/plant_disease_detector.dart → your_project/lib/plant_disease_detector.dart
ml_model_package/assets/model.tflite → your_project/assets/model.tflite
ml_model_package/assets/classes.txt → your_project/assets/classes.txt
```

### 2. Update pubspec.yaml

Add these lines to your `pubspec.yaml`:

```yaml
dependencies:
  tflite_flutter: ^0.10.1
  image_picker: ^1.2.0
  tflite_v2: ^1.0.0

flutter:
  assets:
    - assets/model.tflite
    - assets/classes.txt
```

### 3. Add Permissions

#### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### iOS (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to detect plant diseases</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select images</string>
```

### 4. Import and Use

```dart
import 'package:your_project/plant_disease_detector.dart';

// Simple usage
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
);

// Custom styling
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PlantDiseaseDetector(
      title: 'Plant Doctor',
      backgroundColor: Colors.green.shade50,
      appBarColor: Colors.green,
      fabColor: Colors.green.shade600,
    ),
  ),
);
```

### 5. Common Integration Patterns

#### Floating Action Button
```dart
floatingActionButton: FloatingActionButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
  ),
  child: Icon(Icons.camera_alt),
),
```

#### Navigation Drawer
```dart
ListTile(
  leading: Icon(Icons.camera_alt),
  title: Text('Plant Disease Detection'),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
  ),
),
```

#### Bottom Navigation
```dart
BottomNavigationBarItem(
  icon: Icon(Icons.camera_alt),
  label: 'Detect',
),
// In onTap handler:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
);
```

## Testing

1. Run `flutter pub get`
2. Run your app
3. Navigate to the plant disease detection page
4. Take a photo or select from gallery
5. Verify disease detection results

## Troubleshooting

- **Build errors**: Run `flutter clean && flutter pub get`
- **Model not loading**: Check assets are properly declared in pubspec.yaml
- **Camera not working**: Verify permissions are added to manifest files
- **No results**: Try with clearer images of supported plant diseases

## Supported Diseases

- Corn Gray Leaf Spot
- Pepper Bell Bacterial Spot  
- Strawberry Leaf Scorch
