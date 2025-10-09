import 'package:flutter/material.dart';
import 'package:plant_disease_detector/plant_disease_detector.dart';

/// Example app showing how to integrate the Plant Disease Detection ML Model
class PlantDiseaseExampleApp extends StatelessWidget {
  const PlantDiseaseExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Disease Detection Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Disease Detection Example'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Plant Disease Detection ML Model',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Detect plant diseases using AI-powered image classification',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlantDiseaseDetectionPage(),
                  ),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Open Disease Detection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlantDiseaseDetector(
                      title: 'Custom Plant Doctor',
                      backgroundColor: Colors.blue.shade50,
                      appBarColor: Colors.blue,
                      fabColor: Colors.blue.shade600,
                      confidenceThreshold: 0.5,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: const Text('Custom Styled Detection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            const Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supported Diseases:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Corn Gray Leaf Spot'),
                    Text('• Pepper Bell Bacterial Spot'),
                    Text('• Strawberry Leaf Scorch'),
                    SizedBox(height: 8),
                    Text(
                      'The model provides treatment recommendations for each detected disease.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlantDiseaseDetectionPage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

void main() {
  runApp(const PlantDiseaseExampleApp());
}
