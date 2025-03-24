import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/app_utils.dart';
import 'package:movie_app/features/authencation/domain/entities/user_entity.dart';
import 'package:movie_app/features/authencation/domain/usecase/login_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.init()) {
    on<AuthenticationLoginEvent>(_onAuthencationLoginEvent);
    // on<AuthencationLogoutEvent>(_onAuthencationLogoutEvent);
    // on<AuthencationRegisterEvent>(_onAuthencationRegisterEvent);
  }

  Future<void> _onAuthencationLoginEvent(
    AuthenticationLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.isLoading == LoadingState.loading) {
      return;
    }

    emit(state.copyWith(isLoading: LoadingState.loading, error: null));

    final email = event.email.trim();
    final password = event.password.trim();

    if (email.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Email can't be empty.",
      ));
      return;
    }

    if (!validateEmail(email)) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Invalid email format.",
      ));
      return;
    }

    if (password.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Password can't be empty.",
      ));
      return;
    }

    try {
      final loginUseCase = getIt<LoginUseCase>();
      final user = await loginUseCase(email, password);
      emit(state.copyWith(
        isLoading: LoadingState.finished,
        user: user,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.code == 'user-not-found'
            ? 'No user found for that email.'
            : e.code == 'wrong-password'
                ? 'Wrong password provided for that user.'
                : e.code == 'invalid-email'
                    ? 'Invalid email provided.'
                    : e.code,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.toString(),
      ));
    }
  }

  // Future<void> _onAuthencationRegisterEvent(
  //   AuthenticationRegisterEvent event,
  //   Emitter<AuthenticationState> emit,
  // ) async {
  //   if (state.isLoading == LoadingState.loading) {
  //     return;
  //   }

  //   emit(state.copyWith(isLoading: LoadingState.loading, error: null));

  //   final email = event.email.trim();
  //   final password = event.password.trim();
  //   final passwordConfirm = event.passwordConfirm.trim();
  //   final name = event.name.trim();

  //   if (email.isEmpty) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: "Email can't be empty.",
  //     ));
  //     return;
  //   }

  //   if (!validateEmail(email)) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: "Invalid email format.",
  //     ));
  //     return;
  //   }

  //   if (name.isEmpty) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: "Name can't be empty.",
  //     ));
  //     return;
  //   }

  //   if (password.isEmpty || passwordConfirm.isEmpty) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: "Password can't be empty.",
  //     ));
  //     return;
  //   }

  //   if (password != passwordConfirm) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: "Passwords do not match.",
  //     ));
  //     return;
  //   }

  //   try {
  //     final registerUseCase = getIt<RegisterUseCase>();
  //     final user = await registerUseCase(email, password);

  //     // Cập nhật thông tin người dùng (bao gồm tên)
  //     await user.updateDisplayName(name);

  //     emit(state.copyWith(
  //       isLoading: LoadingState.finished,
  //       user: user,
  //     ));
  //   } on FirebaseAuthException catch (e) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: e.code == 'weak-password'
  //           ? 'The password provided is too weak.'
  //           : e.code == 'email-already-in-use'
  //               ? 'The account already exists for that email.'
  //               : e.code == 'invalid-email'
  //                   ? 'Invalid email provided.'
  //                   : e.code,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: e.toString(),
  //     ));
  //   }
  // }

  void _setLoadingState(Emitter<AuthenticationState> emit) {
    emit(
      state.copyWith(
        isLoading: LoadingState.loading,
        error: null,
      ),
    );
  }
}
