import 'package:equatable/equatable.dart';
import 'package:movie_app/features/authentication/domain/entities/subscription_plan.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

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
class WatchedEpisode {
  final Duration duration; // Thời gian xem
  final String serverName; // Tên server (Vietsub, Lồng Tiếng, Thuyết Minh)

  const WatchedEpisode({
    required this.duration,
    required this.serverName,
  });

  Map<String, dynamic> toJson() {
    return {
      'duration': duration.inSeconds,
      'serverName': serverName,
    };
  }

  factory WatchedEpisode.fromJson(Map<String, dynamic> json) {
    return WatchedEpisode(
      duration: Duration(seconds: json['duration'] as int),
      serverName: json['serverName'] as String,
    );
  }
}

class WatchedMovie extends Equatable {
  final String movieId;
  final bool isSeries;
  final String name;
  final String thumbUrl;
  final int episodeTotal;
  final int time;
  final Map<int, WatchedEpisode> watchedEpisodes;

  const WatchedMovie({
    required this.movieId,
    required this.isSeries,
    required this.name,
    required this.thumbUrl,
    required this.episodeTotal,
    required this.time,
    this.watchedEpisodes = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'isSeries': isSeries,
      'name': name,
      'thumbUrl': thumbUrl,
      'episodeTotal': episodeTotal,
      'time': time,
      'watchedEpisodes': watchedEpisodes.map(
        (episode, watchedEpisode) => MapEntry(
          episode.toString(),
          watchedEpisode.toJson(),
        ),
      ),
    };
  }

  factory WatchedMovie.fromJson(Map<String, dynamic> json) {
    final watchedEpisodesJson =
        json['watchedEpisodes'] as Map<String, dynamic>? ?? {};
    return WatchedMovie(
      movieId: json['movieId'] as String,
      isSeries: json['isSeries'] as bool,
      name: json['name'] as String,
      thumbUrl: json['thumbUrl'] as String,
      episodeTotal: json['episodeTotal'] as int? ?? 0,
      time: json['time'] as int? ?? 0,
      watchedEpisodes: watchedEpisodesJson.map(
        (episode, data) => MapEntry(
          int.parse(episode),
          WatchedEpisode.fromJson(data as Map<String, dynamic>),
        ),
      ),
    );
  }

  MovieEntity toMovieEntity() {
    final int watchedCount = watchedEpisodes.length;
    // Tổng số tập
    final String totalEpisodes = episodeTotal.toString();
    // Định dạng time thành "Tập đã xem / Tổng số tập"
    final String timeDisplay = '$watchedCount/$totalEpisodes';

    // Tập hiện tại (tập mới nhất đã xem)
    final String episodeCurrent = watchedEpisodes.isNotEmpty
        ? watchedEpisodes.keys.reduce((a, b) => a > b ? a : b).toString()
        : '0';

    return MovieEntity(
      id: movieId,
      name: name,
      slug: movieId, // Sử dụng movieId làm slug
      originName: name, // Sử dụng name làm originName
      content: '', // Không có thông tin content, để trống
      type: isSeries ? 'series' : 'single',
      status: 'completed', // Giá trị mặc định
      posterUrl: thumbUrl, // Sử dụng thumbUrl làm posterUrl
      thumbUrl: thumbUrl,
      subDocquyen: false, // Giá trị mặc định
      chieurap: false, // Giá trị mặc định
      trailerUrl: '', // Không có thông tin trailer, để trống
      time: timeDisplay,
      episodeCurrent:
          'Tập: $episodeCurrent', // Sử dụng episodeCurrent đã tính toán
      episodeTotal: episodeTotal.toString(),
      quality: 'HD', // Giá trị mặc định
      lang: 'Vi', // Giá trị mặc định
      year: DateTime.now().year, // Giá trị mặc định (năm hiện tại)
      voteAverage: 0.0, // Giá trị mặc định
      actor: const [], // Không có thông tin actor, để trống
      director: const [], // Không có thông tin director, để trống
      categories: const [], // Không có thông tin categories, để trống
      countries: const [], // Không có thông tin countries, để trống
      episodes: const [], // Không có thông tin episodes, để trống
      modified: DateTime.now(), // Giá trị mặc định (thời gian hiện tại)
    );
  }

  @override
  List<Object?> get props => [
        movieId,
        isSeries,
        name,
        thumbUrl,
        episodeTotal,
        time,
        watchedEpisodes,
      ];
}
