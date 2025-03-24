import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/features/authencation/data/model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> registerWithEmail(String email, String password);
  Future<void> forgotPassword(String email);
  Future<UserModel> loginWithGoogle();
  Future<void> updateDisplayName(String name);
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

  @override
  Future<UserModel> registerWithEmail(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user == null) {
      throw Exception('Failed to register: No user data returned.');
    }
    return UserModel(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email ?? '',
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In cancelled.');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.user == null) {
      throw Exception('Failed to sign in with Google: No user data returned.');
    }
    return UserModel(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email ?? '',
    );
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    await user.updateDisplayName(name);
    await user.reload();
  }
}
