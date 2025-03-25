import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/features/authencation/domain/entities/subscription_plan.dart';
import 'package:movie_app/features/authencation/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.avatar,
    super.subscriptionPlan,
    super.likedMovies = const [],
    super.watchedMovies = const [],
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      avatar: 0,
      subscriptionPlan: null,
      likedMovies: const [],
      watchedMovies: const [],
    );
  }

  factory UserModel.init() {
    return const UserModel(
      uid: '',
      email: '',
      name: '',
      avatar: 0,
      subscriptionPlan: SubscriptionPlan.basic,
      likedMovies: [],
      watchedMovies: [],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as int,
      subscriptionPlan: SubscriptionPlan.fromJson(
          json['subscriptionPlan'] as String? ?? 'basic'),
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
    final json = {
      'uid': uid,
      'email': email,
      'name': name,
      'avatar': avatar,
      'likedMovies': likedMovies,
      'watchedMovies': watchedMovies.map((e) => e.toJson()).toList(),
    };
    // Chỉ thêm subscriptionPlan vào JSON nếu nó không phải null
    if (subscriptionPlan != null) {
      json['subscriptionPlan'] = subscriptionPlan!.toJson();
    }
    return json;
  }
}
