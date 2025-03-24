import 'package:movie_app/features/authencation/domain/entities/user_entity.dart';
import 'package:movie_app/features/authencation/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.loginWithEmail(email, password);
  }
}