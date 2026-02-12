# Secrets Management Guide

This document explains how to manage API keys and secrets securely in the FarmSphere application.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Required API Keys](#required-api-keys)
3. [Setup Instructions](#setup-instructions)
4. [Security Best Practices](#security-best-practices)
5. [CI/CD Configuration](#cicd-configuration)
6. [Troubleshooting](#troubleshooting)

## Quick Start

### For Development

1. **Copy the template file:**
   ```bash
   cp lib/secrets.dart.template lib/secrets.dart
   ```

2. **Get a Gemini API key** (required for chatbot and AI agents):
   - Visit https://makersuite.google.com/app/apikey
   - Sign in with your Google account
   - Click "Create API Key"
   - Copy the generated key

3. **Update secrets.dart:**
   ```dart
   const String geminiApiKey = 'YOUR_ACTUAL_API_KEY_HERE';
   ```

4. **Verify .gitignore:**
   ```bash
   # Check that secrets.dart is ignored
   git status
   # secrets.dart should NOT appear in the list
   ```

## Required API Keys

### Essential (Required)

| Service | Used For | Free Tier | Get Key From |
|---------|----------|-----------|--------------|
| **Google Gemini AI** | AI Chatbot, Agent recommendations | 60 requests/min | [https://makersuite.google.com](https://makersuite.google.com/app/apikey) |

### Optional (Nice to Have)

| Service | Used For | Free Tier | Get Key From |
|---------|----------|-----------|--------------|
| Data.gov.in | MSP crop prices | Yes | [https://data.gov.in](https://data.gov.in/) |
| RapidAPI | Premium weather data | Limited | [https://rapidapi.com](https://rapidapi.com/) |

### Not Required

The app currently works without these, using free alternatives or mock data:
- Weather: Uses wttr.in (no API key needed)
- Market Prices: Has built-in fallback data
- Plant Disease: Uses local Flask backend

## Setup Instructions

### Step 1: Create secrets.dart

```bash
cd lib
cp secrets.dart.template secrets.dart
```

### Step 2: Get API Keys

#### Google Gemini API (Required)

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with Google account
3. Click "Create API Key"
4. Select existing Google Cloud project or create new one
5. Copy the API key
6. Paste into `secrets.dart`:
   ```dart
   const String geminiApiKey = 'AIzaSy...your_actual_key';
   ```

#### Data.gov.in API (Optional)

1. Visit [data.gov.in](https://data.gov.in/)
2. Register for an account
3. Navigate to API section
4. Request API key
5. Update in secrets.dart

### Step 3: Verify Configuration

```bash
# Check that secrets.dart exists
ls lib/secrets.dart

# Verify it's not tracked by git
git status | grep secrets.dart
# Should show nothing (file is ignored)

# Test the app
flutter run
```

## Security Best Practices

### Development Environment

✅ **DO:**
- Keep `secrets.dart` in `.gitignore`
- Use different API keys for dev and production
- Set up API key restrictions in Google Cloud Console
- Rotate keys every 90 days
- Monitor API usage regularly

❌ **DON'T:**
- Never commit `secrets.dart` to version control
- Never hardcode secrets in source files
- Never share API keys via email/chat
- Never use production keys in development
- Never screenshot code containing keys

### API Key Restrictions

Configure restrictions in Google Cloud Console:

1. **Application Restrictions:**
   - For mobile: Set Android/iOS package restrictions
   - For web: Set HTTP referrer restrictions

2. **API Restrictions:**
   - Limit key to only Gemini API
   - Disable unused services

### Rate Limiting

Monitor and set up alerts:
- Gemini API: 60 requests/minute (free tier)
- Set up quotas in Google Cloud Console
- Implement exponential backoff in code

### Git Safety

Ensure `.gitignore` contains:
```gitignore
# Secrets
lib/secrets.dart
*.env
.env.*

# API keys and secrets
**/secrets/
**/*secret*
**/*key*.json
```

Verify exclusion:
```bash
# This should NOT list secrets.dart
git ls-files | grep secrets
```

### Accidental Commit Recovery

If you accidentally commit secrets:

```bash
# Remove from current commit (before push)
git rm --cached lib/secrets.dart
git commit --amend

# If already pushed, rotate ALL exposed keys immediately
# Then use git-filter-repo to remove from history:
git filter-repo --path lib/secrets.dart --invert-paths

# Force push (destructive - warn team first!)
git push --force-with-lease
```

**Important:** After any exposure, rotate all API keys immediately!

## CI/CD Configuration

### Environment Variables

Store secrets as CI/CD environment variables:

**GitHub Actions:**
```yaml
name: Build

on: [push]

env:
  GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Create secrets.dart
        run: |
          cat > lib/secrets.dart << EOF
          const String geminiApiKey = '${{ secrets.GEMINI_API_KEY }}';
          const String rapidApiKey = '${{ secrets.RAPID_API_KEY }}';
          const String dataGovApiKey = '${{ secrets.DATA_GOV_API_KEY }}';
          EOF
      
      - name: Build app
        run: flutter build apk
```

**GitLab CI:**
```yaml
variables:
  GEMINI_API_KEY: $CI_GEMINI_API_KEY

build:
  script:
    - echo "const String geminiApiKey = '$GEMINI_API_KEY';" > lib/secrets.dart
    - flutter build apk
```

### Secret Scanning

Add pre-commit hooks:

```bash
# Install git-secrets
brew install git-secrets

# Configure
git secrets --install
git secrets --register-aws
git secrets --add 'AIza[0-9A-Za-z-_]{35}'  # Gemini key pattern

# Scan existing history
git secrets --scan-history
```

### Docker Builds

For containerized builds:

```dockerfile
FROM debian:latest

# Accept build arguments
ARG GEMINI_API_KEY
ARG RAPID_API_KEY

# Create secrets.dart during build
RUN echo "const String geminiApiKey = '$GEMINI_API_KEY';" > lib/secrets.dart

# Continue build...
```

Build with secrets:
```bash
docker build \
  --build-arg GEMINI_API_KEY=$GEMINI_API_KEY \
  --build-arg RAPID_API_KEY=$RAPID_API_KEY \
  -t farmsphere .
```

## Troubleshooting

### Issue: "secrets.dart not found" error

**Solution:**
```bash
# Copy template
cp lib/secrets.dart.template lib/secrets.dart

# Edit with your keys
nano lib/secrets.dart
```

### Issue: API key not working

**Checklist:**
1. ✓ Key is correctly copied (no extra spaces)
2. ✓ API is enabled in Google Cloud Console
3. ✓ Billing is set up (if required)
4. ✓ Key restrictions allow your app
5. ✓ Rate limits not exceeded

**Test API key:**
```bash
curl -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Hello"}]}]}' \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_KEY"
```

### Issue: secrets.dart appears in git status

**Solution:**
```bash
# Add to .gitignore
echo "lib/secrets.dart" >> .gitignore

# Remove from git tracking
git rm --cached lib/secrets.dart
git commit -m "Remove secrets.dart from tracking"
```

### Issue: API quota exceeded

**Solutions:**
1. Check usage in Google Cloud Console
2. Implement caching to reduce requests
3. Add exponential backoff
4. Upgrade to paid tier if needed

**Monitor usage:**
- Gemini API Console: https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com

## Production Deployment

### Using Secret Managers

**AWS Secrets Manager:**
```dart
import 'package:aws_secrets_manager_dart/aws_secrets_manager_dart.dart';

Future<String> getGeminiKey() async {
  final secretsManager = SecretsManager(
    region: 'us-east-1',
  );
  
  final secret = await secretsManager.getSecretValue(
    secretId: 'farmsphere/gemini-api-key',
  );
  
  return secret['apiKey'];
}
```

**Google Secret Manager:**
```dart
import 'package:googleapis/secretmanager/v1.dart';

Future<String> getGeminiKey() async {
  final secretManager = SecretManagerApi(/* auth */);
  
  final name = 'projects/my-project/secrets/gemini-api-key/versions/latest';
  final response = await secretManager.projects.secrets.versions.access(name);
  
  return utf8.decode(base64.decode(response.payload.data));
}
```

### Environment-Based Configuration

```dart
// lib/config.dart
class Config {
  static bool get isProduction => 
    const String.fromEnvironment('ENV') == 'production';
  
  static String get geminiApiKey => 
    isProduction 
      ? const String.fromEnvironment('GEMINI_API_KEY')
      : geminiApiKey; // From secrets.dart
}
```

Build with environment:
```bash
flutter build apk \
  --dart-define=ENV=production \
  --dart-define=GEMINI_API_KEY=$PRODUCTION_KEY
```

## Security Checklist

Before going to production:

- [ ] All secrets in `.gitignore`
- [ ] No secrets committed to git history
- [ ] API keys have appropriate restrictions
- [ ] Rate limiting implemented
- [ ] Error messages don't leak secrets
- [ ] Monitoring and alerting set up
- [ ] Keys are rotated regularly
- [ ] Team has access to key rotation procedure
- [ ] Backup keys available for rotation
- [ ] Incident response plan documented

## Support

For issues with:
- **API keys not working:** Check Google Cloud Console logs
- **Secrets management:** Create an issue in the repository
- **Security concerns:** Contact security@farmsphere.app

## References

- [Google Cloud API Key Best Practices](https://cloud.google.com/docs/authentication/api-keys)
- [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
- [Flutter Environment Variables](https://flutter.dev/docs/deployment/flavors)
- [git-secrets](https://github.com/awslabs/git-secrets)
