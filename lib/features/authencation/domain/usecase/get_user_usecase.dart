import 'package:movie_app/features/authencation/domain/entities/user_entity.dart';
import 'package:movie_app/features/authencation/domain/repository/auth_repository.dart';

class GetUserUseCase {
  final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<UserEntity> call(String uid) async {
    return await repository.getUser(uid);
  }
}
