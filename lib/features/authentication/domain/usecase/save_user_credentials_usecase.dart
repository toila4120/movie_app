import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';

class SaveUserCredentialsUseCase {
  final AuthRepository repository;

  SaveUserCredentialsUseCase(this.repository);

  Future<void> call(String email, String password) async {
    return await repository.saveUserCredentials(email, password);
  }
}
