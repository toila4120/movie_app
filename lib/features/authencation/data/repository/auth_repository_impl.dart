import 'package:movie_app/features/authencation/data/datasources/remote/auth_remote_data_source.dart';
import 'package:movie_app/features/authencation/data/model/user_model.dart';
import 'package:movie_app/features/authencation/domain/entities/user_entity.dart';
import 'package:movie_app/features/authencation/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> loginWithEmail(String email, String password) async {
    try {
      final userModel = await remoteDataSource.loginWithEmail(email, password);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> registerWithEmail(String email, String password) async {
    try {
      final userModel =
          await remoteDataSource.registerWithEmail(email, password);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> loginWithGoogle() async {
    try {
      final userModel = await remoteDataSource.loginWithGoogle();
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateDisplayName(String name) async {
    try {
      await remoteDataSource.updateDisplayName(name);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      await remoteDataSource.updateUser(user as UserModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUser(String uid) async {
    try {
      final userModel = await remoteDataSource.getUser(uid);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }
}
