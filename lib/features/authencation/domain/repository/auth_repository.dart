import 'package:movie_app/features/authencation/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithEmail(String email, String password);
  Future<UserEntity> registerWithEmail(String email, String password);
  Future<void> forgotPassword(String email);
  Future<UserEntity> loginWithGoogle();
  Future<void> updateDisplayName(String name);
}
