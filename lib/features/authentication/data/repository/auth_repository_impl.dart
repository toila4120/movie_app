import 'package:movie_app/features/authentication/data/datasources/local/auth_local_data_source.dart';
import 'package:movie_app/features/authentication/data/datasources/remote/auth_remote_data_source.dart';
import 'package:movie_app/features/authentication/data/model/user_model.dart';
import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/authentication/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

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

  // Remember Me functionality
  @override
  Future<void> saveUserCredentials(String email, String password) async {
    return await localDataSource.saveUserCredentials(email, password);
  }

  @override
  Future<Map<String, String>?> getSavedCredentials() async {
    return await localDataSource.getSavedCredentials();
  }

  @override
  Future<void> clearSavedCredentials() async {
    return await localDataSource.clearSavedCredentials();
  }

  @override
  Future<void> saveRememberMeStatus(bool rememberMe) async {
    return await localDataSource.saveRememberMeStatus(rememberMe);
  }

  @override
  Future<bool> getRememberMeStatus() async {
    return await localDataSource.getRememberMeStatus();
  }
}
