import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/authentication/data/model/user_model.dart';
import 'package:movie_app/features/authentication/domain/usecase/get_user_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_user_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState.init()) {
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<FetchUserEvent>(_onFetchUserEvent);
    on<UpdateAvatarEvent>(_onUpdateAvatarEvent);
  }

  void _onUpdateUserEvent(UpdateUserEvent event, Emitter<AppState> emit) {
    emit(state.copyWith(userModel: event.user));
  }

  Future<void> _onFetchUserEvent(
      FetchUserEvent event, Emitter<AppState> emit) async {
    emit(state.copyWith(isLoading: LoadingState.loading, error: null));

    try {
      final getUserUseCase = getIt<GetUserUseCase>();
      final user = await getUserUseCase(event.uid);
      emit(state.copyWith(
        isLoading: LoadingState.finished,
        userModel: user as UserModel,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateAvatarEvent(
      UpdateAvatarEvent event, Emitter<AppState> emit) async {
    if (state.userModel == null) return;

    emit(state.copyWith(isLoading: LoadingState.loading, error: null));

    try {
      final updatedUser = UserModel(
        uid: state.userModel!.uid,
        email: state.userModel!.email,
        name: state.userModel!.name,
        avatar: event.newAvatar,
        subscriptionPlan: state.userModel!.subscriptionPlan,
        likedMovies: state.userModel!.likedMovies,
        watchedMovies: state.userModel!.watchedMovies,
      );

      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);

      emit(state.copyWith(
        isLoading: LoadingState.finished,
        userModel: updatedUser,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.toString(),
      ));
    }
  }
}
