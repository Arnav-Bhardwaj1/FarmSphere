# AI Chatbot Package

A reusable Flutter widget that provides AI chatbot functionality using Google Dialogflow. This package includes everything you need to integrate an AI assistant into your Flutter application.

## Features

- 🤖 **Google Dialogflow Integration** - Powered by Google's conversational AI
- 💬 **Modern Chat UI** - Clean, responsive chat interface with message bubbles
- 🎨 **Customizable Styling** - Customize colors, text styles, and appearance
- 📱 **Mobile Optimized** - Responsive design that works on all screen sizes
- 🔧 **Easy Integration** - Simple to add to any Flutter project

## Files Included

```
chatbot_package/
├── lib/
│   └── chatbot.dart          # Main chatbot widget implementation
├── assets/
│   ├── dialog_flow_auth.json.template # Template for Google Dialogflow credentials
│   └── dialog_flow_auth.json # Google Dialogflow service account credentials (create from template)
├── pubspec.yaml              # Package dependencies
└── README.md                 # This documentation
```

## Quick Start

### 1. Setup Google Dialogflow Credentials

Before using the chatbot, you need to set up Google Dialogflow credentials:

1. **Copy the template file:**
   ```bash
   cp chatbot_package/assets/dialog_flow_auth.json.template chatbot_package/assets/dialog_flow_auth.json
   ```

2. **Get your Google Cloud Service Account credentials:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one
   - Enable the Dialogflow API
   - Create a Service Account
   - Download the JSON credentials file
   - Replace the placeholder values in `dialog_flow_auth.json` with your actual credentials

3. **Important:** Never commit the actual `dialog_flow_auth.json` file to version control!

### 2. Add to Your Flutter Project

Copy the following files to your Flutter project:

- `lib/chatbot.dart` → `your_project/lib/chatbot.dart`
- `assets/dialog_flow_auth.json` → `your_project/assets/dialog_flow_auth.json`

### 3. Update pubspec.yaml

Add the required dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dialog_flowtter: ^0.3.3  # Add this line

flutter:
  assets:
    - assets/dialog_flow_auth.json  # Add this line
```

### 4. Import and Use

```dart
import 'package:your_project/chatbot.dart';

// Basic usage
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChatbotPage()),
);

// Or with custom styling
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AIChatbot(
      title: 'My AI Assistant',
      backgroundColor: Colors.blue.shade50,
      appBarColor: Colors.blue,
      inputContainerColor: Colors.blue.shade600,
      hintText: 'Type your message...',
    ),
  ),
);
```

## Configuration

### Google Dialogflow Setup

1. **Create a Dialogflow Agent:**
   - Go to [Dialogflow Console](https://dialogflow.cloud.google.com/)
   - Create a new agent
   - Set up intents and responses

2. **Service Account Setup:**
   - Go to Google Cloud Console
   - Enable Dialogflow API
   - Create a service account
   - Download the JSON key file
   - Replace the content in `assets/dialog_flow_auth.json` with your credentials

3. **Update Project ID:**
   - Make sure the `project_id` in `dialog_flow_auth.json` matches your Dialogflow agent's project

## Customization Options

The `AIChatbot` widget supports extensive customization:

```dart
AIChatbot(
  title: 'Custom Title',                    // App bar title
  backgroundColor: Colors.white,            // Background color
  appBarColor: Colors.blue,                // App bar color
  inputContainerColor: Colors.blue.shade600, // Input area color
  sendButtonColor: Colors.blue,             // Send button color
  hintText: 'Ask me anything...',           // Input placeholder
  titleStyle: TextStyle(fontSize: 20),      // App bar title style
  hintStyle: TextStyle(color: Colors.grey), // Input hint style
)
```

## Integration Examples

### Floating Action Button
```dart
floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatbotPage()),
    );
  },
  child: Icon(Icons.chat),
),
```

### Navigation Menu
```dart
ListTile(
  leading: Icon(Icons.chat),
  title: Text('AI Assistant'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatbotPage()),
    );
  },
),
```

### Custom Button
```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatbotPage()),
    );
  },
  child: Text('Ask AI'),
),
```

## Troubleshooting

### Common Issues

1. **Dialogflow Authentication Error:**
   - Verify your service account JSON file is correct
   - Ensure Dialogflow API is enabled in Google Cloud Console
   - Check that the project ID matches your Dialogflow agent

2. **No Response from Bot:**
   - Check your internet connection
   - Verify your Dialogflow agent has proper intents configured
   - Check console logs for error messages

3. **Build Errors:**
   - Run `flutter pub get` after adding dependencies
   - Ensure Flutter SDK version is compatible (>=3.1.0)

### Error Handling

The widget includes basic error handling, but you may want to add more sophisticated error handling based on your app's needs:

```dart
// Example of enhanced error handling
try {
  DetectIntentResponse response = await dialogFlowtter.detectIntent(
    queryInput: QueryInput(text: TextInput(text: text)),
  );
  // Handle response
} catch (e) {
  // Show user-friendly error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Unable to connect to AI service')),
  );
}
```

## Dependencies

- `dialog_flowtter: ^0.3.3` - Google Dialogflow integration
- `flutter` - Flutter framework

## License

This package is provided as-is for integration into your Flutter projects. Make sure to comply with Google Dialogflow's terms of service when using their API.

## Support

For issues related to:
- **Dialogflow API**: Check [Dialogflow Documentation](https://cloud.google.com/dialogflow/docs)
- **Flutter Integration**: Check [Flutter Documentation](https://flutter.dev/docs)
- **Package Issues**: Review the code and customize as needed for your specific use case
