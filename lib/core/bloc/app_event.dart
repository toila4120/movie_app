part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class UpdateUserEvent extends AppEvent {
  final UserModel user;

  const UpdateUserEvent({required this.user});

  @override
  List<Object?> get props => [
        user,
      ];
}

class FetchUserEvent extends AppEvent {
  final String uid;

  const FetchUserEvent({required this.uid});

  @override
  List<Object?> get props => [
        uid,
      ];
}

class UpdateAvatarEvent extends AppEvent {
  final int newAvatar;

  const UpdateAvatarEvent({
    required this.newAvatar,
  });
}
