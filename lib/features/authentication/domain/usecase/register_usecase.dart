import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.registerWithEmail(email, password);
  }
}
