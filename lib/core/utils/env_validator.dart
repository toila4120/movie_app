import 'package:flutter/foundation.dart';
import 'package:movie_app/core/constants/api_keys.dart';
import 'package:movie_app/core/utils/app_log.dart';

/// Utility to validate environment variables
class EnvValidator {
  /// Validates that all required environment variables are set
  /// Logs warnings for missing or invalid variables
  static void validateEnv() {
    if (ApiKeys.geminiApiKey == 'API_KEY_NOT_FOUND' ||
        ApiKeys.geminiApiKey.isEmpty) {
      AppLog.warning('GEMINI_API_KEY not found in .env file');
      if (kDebugMode) {
        print('⚠️ Warning: GEMINI_API_KEY not found in .env file');
        print(
            'Please create a .env file in the root of the project with your Gemini API key:');
        print('GEMINI_API_KEY=YOUR_GEMINI_API_KEY');
      }
    }
  }
}
