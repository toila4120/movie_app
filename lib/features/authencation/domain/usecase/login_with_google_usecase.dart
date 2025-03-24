import 'package:movie_app/features/authencation/domain/entities/user_entity.dart';
import 'package:movie_app/features/authencation/domain/repository/auth_repository.dart';

class LoginWithGoogleUsecase {
  const LoginWithGoogleUsecase(this.repository);

  final AuthRepository repository;

  Future<UserEntity> call() async {
    return await repository.loginWithGoogle();
  }
}
