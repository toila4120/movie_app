import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/features/authencation/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;

  AuthRemoteDataSourceImpl(this._auth);

  @override
  Future<UserModel> loginWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user == null) {
      throw Exception('Failed to sign in: No user data returned.');
    }
    return UserModel(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email ?? '',
    );
  }
}
