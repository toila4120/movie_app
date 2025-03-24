import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/features/authencation/domain/entities/subscription_plan.dart';
import 'package:movie_app/features/authencation/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
    super.subscriptionPlan = SubscriptionPlan.basic,
    super.likedMovies = const [],
    super.watchedMovies = const [],
  });

  // Tạo UserModel từ Firebase User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      subscriptionPlan: SubscriptionPlan.basic, // Mặc định là basic
      likedMovies: const [],
      watchedMovies: const [],
    );
  }

  // Tạo UserModel từ dữ liệu Firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      subscriptionPlan: SubscriptionPlan.fromJson(json['subscriptionPlan'] as String? ?? 'basic'),
      likedMovies: (json['likedMovies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      watchedMovies: (json['watchedMovies'] as List<dynamic>?)
              ?.map((e) => WatchedMovie.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  // Chuyển UserModel thành JSON để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'subscriptionPlan': subscriptionPlan.toJson(),
      'likedMovies': likedMovies,
      'watchedMovies': watchedMovies.map((e) => e.toJson()).toList(),
    };
  }
}
