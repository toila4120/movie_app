import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/app_utils.dart';

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
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (state.isLoading == LoadingState.loading) {
      return;
    }

    _setLoadingState(emit);

    final email = event.email.trim();
    final password = event.password.trim();

    if (email.isEmpty) {
      emit(
        state.copyWith(
          isLoading: LoadingState.error,
          error: "Email can't be empty.",
        ),
      );
      return;
    }

    if (!validateEmail(email)) {
      emit(
        state.copyWith(
          isLoading: LoadingState.error,
          error: "Invalid email format.",
        ),
      );
      return;
    }

    if (password.isEmpty) {
      emit(
        state.copyWith(
          isLoading: LoadingState.error,
          error: "Password can't be empty.",
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );
      if (userCredential.user != null) {
        emit(state.copyWith(isLoading: LoadingState.finished));
      } else {
        emit(state.copyWith(
          isLoading: LoadingState.error,
          error: 'An error occurred while signing in.',
        ));
      }
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

  void _setLoadingState(Emitter<AuthenticationState> emit) {
    emit(
      state.copyWith(
        isLoading: LoadingState.loading,
        error: null,
      ),
    );
  }
}
