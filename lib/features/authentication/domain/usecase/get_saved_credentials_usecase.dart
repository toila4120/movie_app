import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';

class GetSavedCredentialsUseCase {
  final AuthRepository repository;

  GetSavedCredentialsUseCase(this.repository);

  Future<Map<String, String>?> call() async {
    return await repository.getSavedCredentials();
  }
}
