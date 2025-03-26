import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/features/authentication/data/model/user_model.dart';
import 'package:movie_app/features/authentication/domain/entities/subscription_plan.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> registerWithEmail(String email, String password);
  Future<void> forgotPassword(String email);
  Future<UserModel> loginWithGoogle();
  Future<void> updateDisplayName(String name);
  Future<void> updateUser(UserModel user);
  Future<UserModel> getUser(String uid);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._auth)
      : _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> loginWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user == null) {
      throw Exception('Failed to sign in: No user data returned.');
    }

    // Lấy dữ liệu từ Firestore
    final doc = await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    if (!doc.exists) {
      throw Exception(
          'User data not found in Firestore. Please register first.');
    }

    return UserModel.fromJson(doc.data()!);
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
    final userModel = UserModel.fromFirebaseUser(userCredential.user!);

    // Đăng ký người dùng mới, đặt subscriptionPlan mặc định là basic
    final newUserModel = UserModel(
      uid: userModel.uid,
      email: userModel.email,
      name: userModel.name,
      avatar: userModel.avatar,
      subscriptionPlan:
          SubscriptionPlan.basic, // Mặc định là basic cho người dùng mới
      likedMovies: userModel.likedMovies,
      watchedMovies: userModel.watchedMovies,
    );
    await _firestore.collection('users').doc(newUserModel.uid).set(
          newUserModel.toJson(),
          SetOptions(merge: true),
        );

    return newUserModel;
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
    final userModel = UserModel.fromFirebaseUser(userCredential.user!);

    // Lấy dữ liệu hiện có từ Firestore
    final doc = await _firestore.collection('users').doc(userModel.uid).get();
    if (doc.exists) {
      // Nếu tài liệu đã tồn tại, không ghi đè subscriptionPlan
      return UserModel.fromJson(doc.data()!);
    } else {
      // Nếu tài liệu chưa tồn tại, tạo mới với subscriptionPlan mặc định là basic
      final newUserModel = UserModel(
        uid: userModel.uid,
        email: userModel.email,
        name: userModel.name,
        avatar: userModel.avatar,
        subscriptionPlan:
            SubscriptionPlan.basic, // Mặc định là basic cho người dùng mới
        likedMovies: userModel.likedMovies,
        watchedMovies: userModel.watchedMovies,
      );
      await _firestore.collection('users').doc(newUserModel.uid).set(
            newUserModel.toJson(),
            SetOptions(merge: true),
          );
      return newUserModel;
    }
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    await user.updateDisplayName(name);
    await user.reload();

    // Cập nhật tên trong Firestore
    await _firestore.collection('users').doc(user.uid).update({
      'name': name,
    });
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(
          user.toJson(),
          SetOptions(merge: true),
        );
  }

  // @override
  // Future<void> signOut() async {
  //   await _auth.signOut();
  // }

  @override
  Future<UserModel> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception('User not found in Firestore.');
    }
    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<void> forgotPassword(String email) {
    throw UnimplementedError();
  }
}
