import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';

class GetRememberMeStatusUseCase {
  final AuthRepository repository;

  GetRememberMeStatusUseCase(this.repository);

  Future<bool> call() async {
    return await repository.getRememberMeStatus();
  }
}
