import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithEmail(String email, String password);
  Future<UserEntity> registerWithEmail(String email, String password);
  Future<void> forgotPassword(String email);
  Future<UserEntity> loginWithGoogle();
  Future<void> updateDisplayName(String name);
  Future<void> updateUser(UserEntity user);
  Future<UserEntity> getUser(String uid);

  // Remember Me functionality
  Future<void> saveUserCredentials(String email, String password);
  Future<Map<String, String>?> getSavedCredentials();
  Future<void> clearSavedCredentials();
  Future<void> saveRememberMeStatus(bool rememberMe);
  Future<bool> getRememberMeStatus();
}
