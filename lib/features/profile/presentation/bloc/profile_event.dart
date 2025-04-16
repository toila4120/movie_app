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
