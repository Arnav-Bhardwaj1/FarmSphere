# Platform Permissions Setup Guide

This document provides instructions for setting up platform permissions for the AI Agent System and other features in FarmSphere.

## Creating Platform Directories

If the platform directories don't exist yet, create them using:

```bash
# Create Android platform files
flutter create --platforms=android .

# Create iOS platform files
flutter create --platforms=ios .
```

## Android Permissions

### AndroidManifest.xml Location
`android/app/src/main/AndroidManifest.xml`

### Required Permissions

Add these permissions inside the `<manifest>` tag, before the `<application>` tag:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Internet access for API calls -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- Network state for connectivity checks -->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <!-- Camera for crop health scanning -->
    <uses-permission android:name="android.permission.CAMERA"/>
    
    <!-- Storage for image caching -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="32"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32"/>
    
    <!-- For Android 13+ (API 33+) media permissions -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    
    <!-- Location access for weather data -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    
    <!-- Background location (if needed for agent system) -->
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
    
    <!-- Notifications -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <!-- Wake lock for background tasks -->
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    
    <!-- Receive boot completed for agent scheduling -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    
    <!-- Foreground service for long-running tasks -->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    
    <!-- Schedule exact alarms for agent tasks -->
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    
    <!-- For WorkManager and background execution -->
    <uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"/>
    
    <application
        android:label="FarmSphere"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Camera feature declaration -->
        <uses-feature android:name="android.hardware.camera" android:required="false"/>
        <uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
        
        <!-- WorkManager initializer -->
        <provider
            android:name="androidx.startup.InitializationProvider"
            android:authorities="${applicationId}.androidx-startup"
            android:exported="false"
            tools:node="merge">
            <meta-data
                android:name="androidx.work.WorkManagerInitializer"
                android:value="androidx.startup" />
        </provider>
        
        <!-- Main Activity and other components -->
        <!-- ... existing content ... -->
        
    </application>
</manifest>
```

### build.gradle Configuration

Update `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34  // Updated for latest Android
    
    defaultConfig {
        minSdkVersion 21      // Minimum API level
        targetSdkVersion 34   // Target API level
        // ... other config
    }
}
```

## iOS Permissions

### Info.plist Location
`ios/Runner/Info.plist`

### Required Permissions

Add these keys inside the `<dict>` tag:

```xml
<dict>
    <!-- Camera access for crop health scanning -->
    <key>NSCameraUsageDescription</key>
    <string>FarmSphere needs camera access to scan and diagnose crop diseases using AI</string>
    
    <!-- Photo library access -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>FarmSphere needs access to save crop health images to your photo library</string>
    
    <!-- Photo library add-only access (iOS 11+) -->
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>FarmSphere needs permission to save crop health images</string>
    
    <!-- Location access for weather data -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>FarmSphere uses your location to provide accurate local weather forecasts and alerts</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>FarmSphere needs location access to provide weather alerts even when the app is in the background</string>
    
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>FarmSphere uses your location to deliver timely weather alerts and farming recommendations</string>
    
    <!-- Background modes -->
    <key>UIBackgroundModes</key>
    <array>
        <string>fetch</string>
        <string>processing</string>
        <string>location</string>
    </array>
    
    <!-- Background fetch interval (seconds) -->
    <key>BGTaskSchedulerPermittedIdentifiers</key>
    <array>
        <string>com.farmsphere.agent.refresh</string>
        <string>com.farmsphere.weather.update</string>
    </array>
    
    <!-- Notifications -->
    <key>UIUserNotificationSettings</key>
    <dict>
        <key>UIUserNotificationTypeAlert</key>
        <true/>
        <key>UIUserNotificationTypeBadge</key>
        <true/>
        <key>UIUserNotificationTypeSound</key>
        <true/>
    </dict>
    
    <!-- ... existing keys ... -->
</dict>
```

### Podfile Configuration

Update `ios/Podfile`:

```ruby
platform :ios, '12.0'  # Minimum iOS version

# Enable background modes
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

## Runtime Permission Requests

The app handles runtime permissions through Flutter packages:

- **Camera**: `permission_handler` package (if not already included)
- **Location**: Built into Flutter location services
- **Notifications**: `flutter_local_notifications` package (already included)
- **Storage**: `permission_handler` package (if needed)

### Adding permission_handler

Add to `pubspec.yaml` if not present:

```yaml
dependencies:
  permission_handler: ^11.0.0
```

### Usage Example

```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();
  return status.isGranted;
}

Future<bool> requestLocationPermission() async {
  final status = await Permission.location.request();
  return status.isGranted;
}

Future<bool> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  return status.isGranted;
}
```

## Testing Permissions

### Android Testing
1. Run app on emulator or device
2. Check logcat for permission requests: `flutter logs`
3. Manually revoke permissions: Settings > Apps > FarmSphere > Permissions
4. Test permission request flows

### iOS Testing
1. Run app on simulator or device
2. Check Xcode console for permission requests
3. Reset permissions: Settings > General > Reset > Reset Location & Privacy
4. Test permission request flows

## Troubleshooting

### Android Issues

**Issue**: Background tasks not running
- **Solution**: Disable battery optimization for FarmSphere in Settings

**Issue**: Notifications not showing
- **Solution**: Enable notification permissions for Android 13+ (API 33+)

**Issue**: Camera not working
- **Solution**: Check that camera feature is declared in manifest

### iOS Issues

**Issue**: Background fetch not working
- **Solution**: Enable "Background fetch" in Xcode capabilities

**Issue**: Location updates stopped
- **Solution**: Request "Always" location permission, not just "When In Use"

**Issue**: Notifications not appearing
- **Solution**: Check notification settings in iOS Settings app

## Security Best Practices

1. **Request permissions when needed**: Don't request all permissions at app start
2. **Explain why**: Show clear explanations before requesting permissions
3. **Handle denials gracefully**: App should work with reduced functionality if permissions denied
4. **Respect user privacy**: Only use permissions for stated purposes
5. **Background location**: Only request if absolutely necessary for agent system

## Verification Checklist

Before releasing:

- [ ] All required permissions added to AndroidManifest.xml
- [ ] All required permissions added to Info.plist
- [ ] Runtime permission requests implemented in code
- [ ] Permission explanations clear and user-friendly
- [ ] App works gracefully when permissions denied
- [ ] Background tasks tested on real devices
- [ ] Notifications tested on both platforms
- [ ] Camera functionality tested
- [ ] Location services tested

## Notes

- Android 6.0+ (API 23+) requires runtime permission requests
- iOS always requires runtime permission requests
- Some permissions (like notifications) must be requested at runtime on both platforms
- Background location requires additional justification in App Store review
- WorkManager handles background execution on Android automatically
- iOS background tasks have strict time limits (30 seconds for background fetch)
