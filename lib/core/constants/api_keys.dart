import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Keys utility class - loads keys from .env file
class ApiKeys {
  /// Returns the Gemini API key from environment variables
  /// If not found, returns a fallback message
  static String get geminiApiKey =>
      dotenv.env['GEMINI_API_KEY'] ?? 'API_KEY_NOT_FOUND';
}
