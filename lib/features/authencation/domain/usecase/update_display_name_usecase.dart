import 'package:movie_app/features/authencation/domain/repository/auth_repository.dart';

class UpdateDisplayNameUseCase {
  final AuthRepository repository;

  UpdateDisplayNameUseCase(this.repository);

  Future<void> call(String name) async {
    await repository.updateDisplayName(name);
  }
}
