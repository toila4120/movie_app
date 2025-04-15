part of 'app_bloc.dart';

class AppState extends Equatable {
  final UserModel? userModel;
  final LoadingState isLoading;
  final String? error;
  final ThemeMode themeMode;

  const AppState({
    this.userModel,
    this.isLoading = LoadingState.pure,
    this.error,
    this.themeMode = ThemeMode.dark,
  });

  factory AppState.init() {
    return const AppState(
      userModel: null,
      isLoading: LoadingState.pure,
      error: null,
      themeMode: ThemeMode.system,
    );
  }

  AppState copyWith({
    UserModel? userModel,
    LoadingState? isLoading,
    String? error,
    ThemeMode? themeMode,
  }) {
    return AppState(
      userModel: userModel ?? this.userModel,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [
        userModel,
        isLoading,
        error,
        themeMode,
      ];
}
