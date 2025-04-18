part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetFavoriteMoviesEvent extends ProfileEvent {
  final UserEntity user;
  const GetFavoriteMoviesEvent({
    required this.user,
  });

  @override
  List<Object> get props => [
        user,
      ];
}

class AddFavoriteMovieEvent extends ProfileEvent {
  final MovieEntity movie;
  const AddFavoriteMovieEvent({
    required this.movie,
  });

  @override
  List<Object> get props => [
        movie,
      ];
}

class RemoveFavoriteMovieEvent extends ProfileEvent {
  final String slug;
  const RemoveFavoriteMovieEvent({
    required this.slug,
  });

  @override
  List<Object> get props => [
        slug,
      ];
}
