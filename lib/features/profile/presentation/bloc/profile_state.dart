part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final List<MovieEntity>? movies;
  final LoadingState? isLoading;
  final String? error;
  const ProfileState({
    this.movies,
    this.isLoading,
    this.error,
  });

  factory ProfileState.init() {
    return const ProfileState(
      movies: [],
      isLoading: LoadingState.pure,
      error: '',
    );
  }

  ProfileState copyWith({
    List<MovieEntity>? movies,
    LoadingState? isLoading,
    String? error,
  }) {
    return ProfileState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        movies,
        isLoading,
        error,
      ];
}
