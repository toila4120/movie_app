import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserCredentials(String email, String password);
  Future<Map<String, String>?> getSavedCredentials();
  Future<void> clearSavedCredentials();
  Future<void> saveRememberMeStatus(bool rememberMe);
  Future<bool> getRememberMeStatus();
  void debugPrintSavedData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  // ignore: constant_identifier_names
  static const String CREDENTIALS_KEY = 'user_credentials';
  // ignore: constant_identifier_names
  static const String REMEMBER_ME_KEY = 'remember_me';

  @override
  Future<void> saveUserCredentials(String email, String password) async {
    // Basic encryption - in a real app, use a more secure method
    final encodedCredentials = base64Encode(utf8.encode(json.encode({
      'email': email,
      'password': password,
    })));

    await sharedPreferences.setString(CREDENTIALS_KEY, encodedCredentials);
    print(
        "🔒 Đã lưu thông tin đăng nhập với email: $email và mật khẩu: ${password == 'google_login' ? 'GOOGLE_LOGIN' : '******'}");
  }

  @override
  Future<Map<String, String>?> getSavedCredentials() async {
    final encodedCredentials = sharedPreferences.getString(CREDENTIALS_KEY);
    if (encodedCredentials == null) {
      print("❌ Không tìm thấy thông tin đăng nhập đã lưu");
      return null;
    }

    try {
      final decodedString = utf8.decode(base64Decode(encodedCredentials));
      final Map<String, dynamic> data = json.decode(decodedString);
      print(
          "🔓 Đã lấy thông tin đăng nhập với email: ${data['email']} và mật khẩu: ${data['password'] == 'google_login' ? 'GOOGLE_LOGIN' : '******'}");
      return {
        'email': data['email'],
        'password': data['password'],
      };
    } catch (e) {
      print("❌ Lỗi khi giải mã thông tin đăng nhập: $e");
      return null;
    }
  }

  @override
  Future<void> clearSavedCredentials() async {
    await sharedPreferences.remove(CREDENTIALS_KEY);
    print("🗑️ Đã xóa thông tin đăng nhập đã lưu");
  }

  @override
  Future<void> saveRememberMeStatus(bool rememberMe) async {
    await sharedPreferences.setBool(REMEMBER_ME_KEY, rememberMe);
    print("✅ Đã lưu trạng thái Remember Me: $rememberMe");
  }

  @override
  Future<bool> getRememberMeStatus() async {
    final status = sharedPreferences.getBool(REMEMBER_ME_KEY) ?? false;
    print("📋 Đã lấy trạng thái Remember Me: $status");
    return status;
  }

  @override
  void debugPrintSavedData() {
    print("\n==== DEBUG SAVED AUTH DATA ====");
    print("Remember Me: ${sharedPreferences.getBool(REMEMBER_ME_KEY)}");
    final encodedCredentials = sharedPreferences.getString(CREDENTIALS_KEY);
    if (encodedCredentials != null) {
      try {
        final decodedString = utf8.decode(base64Decode(encodedCredentials));
        final Map<String, dynamic> data = json.decode(decodedString);
        print("Saved Email: ${data['email']}");
        print(
            "Saved Password Type: ${data['password'] == 'google_login' ? 'GOOGLE' : 'EMAIL/PASSWORD'}");
      } catch (e) {
        print("Error decoding: $e");
      }
    } else {
      print("No saved credentials found");
    }
    print("================================\n");
  }
}
