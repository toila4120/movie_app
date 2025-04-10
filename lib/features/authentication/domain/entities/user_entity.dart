import 'package:equatable/equatable.dart';
import 'package:movie_app/features/authentication/domain/entities/subscription_plan.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String name;
  final int avatar;
  final SubscriptionPlan? subscriptionPlan; // Sử dụng enum
  final List<String> likedMovies; // Danh sách ID của phim đã thả tim
  final List<WatchedMovie> watchedMovies; // Danh sách phim đã xem
  final List<String> likedGenres; // Danh sách thể loại đã thả tim

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.avatar = 0,
    this.subscriptionPlan = SubscriptionPlan.basic, // Mặc định là basic
    this.likedMovies = const [], // Mặc định là danh sách rỗng
    this.watchedMovies = const [], // Mặc định là danh sách rỗng
    this.likedGenres = const [], // Mặc định là danh sách rỗng
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        avatar,
        subscriptionPlan,
        likedMovies,
        watchedMovies,
        likedGenres,
      ];

  UserEntity copyWith({
    String? uid,
    String? email,
    String? name,
    int? avatar,
    SubscriptionPlan? subscriptionPlan,
    List<String>? likedMovies,
    List<WatchedMovie>? watchedMovies,
    List<String>? likedGenres,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      likedMovies: likedMovies ?? this.likedMovies,
      watchedMovies: watchedMovies ?? this.watchedMovies,
      likedGenres: likedGenres ?? this.likedGenres,
    );
  }
}

// Class đại diện cho một bộ phim đã xem
class WatchedMovie {
  final String movieId; // ID của phim
  final bool isSeries; // Phim bộ (true) hay phim lẻ (false)
  final Map<int, Duration> watchedEpisodes; // Tập và thời gian xem của tập đó

  const WatchedMovie({
    required this.movieId,
    required this.isSeries,
    this.watchedEpisodes = const {},
  });

  // Chuyển WatchedMovie thành JSON để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'isSeries': isSeries,
      'watchedEpisodes': watchedEpisodes.map(
        (episode, duration) => MapEntry(
          episode.toString(),
          duration.inSeconds, // Lưu thời gian dưới dạng giây
        ),
      ),
    };
  }

  // Tạo WatchedMovie từ JSON khi đọc từ Firestore
  factory WatchedMovie.fromJson(Map<String, dynamic> json) {
    final watchedEpisodesJson =
        json['watchedEpisodes'] as Map<String, dynamic>? ?? {};
    return WatchedMovie(
      movieId: json['movieId'] as String,
      isSeries: json['isSeries'] as bool,
      watchedEpisodes: watchedEpisodesJson.map(
        (episode, duration) => MapEntry(
          int.parse(episode),
          Duration(seconds: duration as int),
        ),
      ),
    );
  }
}
