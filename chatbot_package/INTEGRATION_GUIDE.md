# Quick Integration Guide

## Step-by-Step Integration

### 1. Copy Required Files

Copy these files from `chatbot_package/` to your Flutter project:

```
chatbot_package/lib/chatbot.dart → your_project/lib/chatbot.dart
chatbot_package/assets/dialog_flow_auth.json → your_project/assets/dialog_flow_auth.json
```

### 2. Update pubspec.yaml

Add these lines to your `pubspec.yaml`:

```yaml
dependencies:
  dialog_flowtter: ^0.3.3

flutter:
  assets:
    - assets/dialog_flow_auth.json
```

### 3. Configure Dialogflow

1. Go to [Dialogflow Console](https://dialogflow.cloud.google.com/)
2. Create a new agent
3. Go to Google Cloud Console
4. Enable Dialogflow API
5. Create a service account and download JSON key
6. Replace content in `assets/dialog_flow_auth.json` with your credentials

### 4. Import and Use

```dart
import 'package:your_project/chatbot.dart';

// Simple usage
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChatbotPage()),
);

// Custom styling
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AIChatbot(
      title: 'My Assistant',
      backgroundColor: Colors.blue.shade50,
      appBarColor: Colors.blue,
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
    MaterialPageRoute(builder: (context) => ChatbotPage()),
  ),
  child: Icon(Icons.chat),
),
```

#### Navigation Drawer
```dart
ListTile(
  leading: Icon(Icons.chat),
  title: Text('AI Assistant'),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChatbotPage()),
  ),
),
```

#### Bottom Navigation
```dart
BottomNavigationBarItem(
  icon: Icon(Icons.chat),
  label: 'Chat',
),
// In onTap handler:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChatbotPage()),
);
```

## Testing

1. Run `flutter pub get`
2. Run your app
3. Navigate to the chatbot
4. Send a test message
5. Verify you get a response from Dialogflow

## Troubleshooting

- **Build errors**: Run `flutter clean && flutter pub get`
- **No response**: Check internet connection and Dialogflow configuration
- **Auth errors**: Verify service account JSON file is correct
