part of 'app_bloc.dart';

class AppState extends Equatable {
  final UserModel? userModel;
  final LoadingState isLoading;
  final String? error;

  const AppState({
    this.userModel,
    this.isLoading = LoadingState.pure,
    this.error,
  });

  factory AppState.init() {
    return const AppState(
      userModel: null,
      isLoading: LoadingState.pure,
      error: null,
    );
  }

  AppState copyWith({
    UserModel? userModel,
    LoadingState? isLoading,
    String? error,
  }) {
    return AppState(
      userModel: userModel ?? this.userModel,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [userModel, isLoading, error];
}
