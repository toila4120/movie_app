import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';

class UpdateUserUseCase {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> call(UserEntity user) async {
    await repository.updateUser(user);
  }
}