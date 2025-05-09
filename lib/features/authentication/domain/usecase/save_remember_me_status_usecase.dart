import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';

class SaveRememberMeStatusUseCase {
  final AuthRepository repository;

  SaveRememberMeStatusUseCase(this.repository);

  Future<void> call(bool rememberMe) async {
    return await repository.saveRememberMeStatus(rememberMe);
  }
}
