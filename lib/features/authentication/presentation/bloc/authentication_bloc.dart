import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/app_utils.dart';
import 'package:movie_app/features/authentication/data/model/user_model.dart';
import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/authentication/domain/usecase/get_remember_me_status_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/get_saved_credentials_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/login_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/login_with_google_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/register_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/save_remember_me_status_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/save_user_credentials_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_display_name_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_user_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUseCase _loginUseCase;
  final SaveUserCredentialsUseCase _saveUserCredentialsUseCase;
  final GetSavedCredentialsUseCase _getSavedCredentialsUseCase;
  final SaveRememberMeStatusUseCase _saveRememberMeStatusUseCase;
  final GetRememberMeStatusUseCase _getRememberMeStatusUseCase;

  AuthenticationBloc(
    this._loginUseCase,
    this._saveUserCredentialsUseCase,
    this._getSavedCredentialsUseCase,
    this._saveRememberMeStatusUseCase,
    this._getRememberMeStatusUseCase,
  ) : super(AuthenticationState.init()) {
    on<AuthenticationLoginEvent>(_onAuthencationLoginEvent);
    on<AuthenticationRegisterEvent>(_onAuthencationRegisterEvent);
    on<AuthenticationForgotPasswordEvent>(_onAuthencationForgotPasswordEvent);
    on<AuthenticationGoogleLoginEvent>(_onAuthenticationGoogleLoginEvent);
    on<LikeMovieEvent>(_onLikeMovieEvent);
    on<UpdateWatchedMovieEvent>(_onUpdateWatchedMovieEvent);
    // on<UpdateSubscriptionPlanEvent>(_onUpdateSubscriptionPlanEvent);
    on<UpdateGenresEvent>(_onUpdateGenresEvent);
    on<CheckSavedCredentialsEvent>(_onCheckSavedCredentialsEvent);
    on<SaveRememberMeEvent>(_onSaveRememberMeEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<RemoveWatchedMovieEvent>(_onRemoveWatchedMovieEvent);
  }

  Future<void> _onSaveRememberMeEvent(
    SaveRememberMeEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _saveRememberMeStatusUseCase(event.rememberMe);

    if (event.rememberMe) {
      await _saveUserCredentialsUseCase(event.email, event.password);
    } else {
      // Clear saved credentials if remember me is turned off
      await _saveUserCredentialsUseCase('', '');
    }
  }

  Future<void> _onCheckSavedCredentialsEvent(
    CheckSavedCredentialsEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    print("\n==== BẮT ĐẦU KIỂM TRA THÔNG TIN ĐĂNG NHẬP ====");
    final isRememberMe = await _getRememberMeStatusUseCase();
    print("🔍 Remember Me đã bật: $isRememberMe");

    if (isRememberMe) {
      emit(state.copyWith(isLoading: LoadingState.loading));

      final credentials = await _getSavedCredentialsUseCase();
      if (credentials != null) {
        final email = credentials['email'];
        final password = credentials['password'];

        print("📧 Email đã lưu: $email");
        print(
            "🔑 Loại mật khẩu đã lưu: ${password == 'google_login' ? 'GOOGLE' : 'EMAIL/PASSWORD'}");

        // Nếu email hoặc password trống, có thể đã đăng xuất trước đó
        if (email == null ||
            password == null ||
            email.isEmpty ||
            password.isEmpty) {
          print("❌ Email hoặc mật khẩu trống, không thể tự động đăng nhập");
          emit(state.copyWith(isLoading: LoadingState.finished));
          return;
        }

        if (password == "google_login") {
          print("🔄 Đang thử đăng nhập tự động bằng Google...");
          // Nếu là đăng nhập Google đã lưu
          try {
            // Ưu tiên sử dụng GoogleSignIn trực tiếp thay vì FirebaseAuth
            final googleLoginUseCase = getIt<LoginWithGoogleUsecase>();
            try {
              print("🔄 Đang gọi GoogleLoginUseCase...");
              final user = await googleLoginUseCase();
              print("✅ Đăng nhập Google thành công: ${user.email}");

              emit(state.copyWith(
                isLoading: LoadingState.finished,
                user: user,
                action: AuthAction.login,
                isRememberMe: true,
              ));
              return;
            } catch (e) {
              print("❌ Lỗi đăng nhập Google: $e");
              // Thử lại với forceWebAuth
              print("🔄 Thử lại GoogleLoginUseCase với force web view...");
              try {
                final user = await googleLoginUseCase();
                print(
                    "✅ Đăng nhập Google thành công sau khi thử lại: ${user.email}");

                emit(state.copyWith(
                  isLoading: LoadingState.finished,
                  user: user,
                  action: AuthAction.login,
                  isRememberMe: true,
                ));
                return;
              } catch (e2) {
                print("❌ Lỗi đăng nhập Google lần 2: $e2");
                emit(state.copyWith(
                  isLoading: LoadingState.error,
                  error:
                      "Không thể tự động đăng nhập bằng Google, vui lòng đăng nhập lại.",
                  savedEmail: email,
                  isRememberMe: true,
                ));
              }
            }
          } catch (e) {
            print("❌ Lỗi chung khi đăng nhập Google: $e");
            emit(state.copyWith(
              isLoading: LoadingState.error,
              error:
                  "Không thể tự động đăng nhập bằng Google, vui lòng đăng nhập lại.",
              savedEmail: email,
              isRememberMe: true,
            ));
          }
        } else if (email.isNotEmpty && password.isNotEmpty) {
          print("🔄 Đang thử đăng nhập tự động bằng email/mật khẩu...");
          // Đăng nhập tự động với email/password
          try {
            final user = await _loginUseCase(email, password);
            print("✅ Đăng nhập email/mật khẩu thành công: ${user.email}");

            emit(state.copyWith(
              isLoading: LoadingState.finished,
              user: user,
              action: AuthAction.login,
              isRememberMe: true,
            ));
            return;
          } catch (e) {
            print("❌ Lỗi đăng nhập email/mật khẩu: $e");
            // Nếu đăng nhập tự động không thành công, vẫn hiện form đăng nhập với thông tin đã lưu
            emit(state.copyWith(
              isLoading: LoadingState.error,
              error: "Không thể tự động đăng nhập, vui lòng đăng nhập lại.",
              savedEmail: email,
              savedPassword: password,
              isRememberMe: true,
            ));
          }
        }
      } else {
        print("❌ Không tìm thấy thông tin đăng nhập đã lưu");
        emit(state.copyWith(
          isLoading: LoadingState.finished,
        ));
      }
    } else {
      print("❌ Remember Me chưa được bật");
      emit(state.copyWith(
        isLoading: LoadingState.finished,
      ));
    }
    print("==== KẾT THÚC KIỂM TRA THÔNG TIN ĐĂNG NHẬP ====\n");
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
        error: "Email không được bỏ trống.",
      ));
      return;
    }

    if (!validateEmail(email)) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Email không đúng định dạng.",
      ));
      return;
    }

    if (password.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Mật khẩu không được để trống.",
      ));
      return;
    }

    try {
      final user = await _loginUseCase(email, password);

      // Save credentials if remember me is checked
      if (event.rememberMe) {
        await _saveRememberMeStatusUseCase(true);
        await _saveUserCredentialsUseCase(email, password);
      } else {
        await _saveRememberMeStatusUseCase(false);
        // Clear stored credentials
        await _saveUserCredentialsUseCase('', '');
      }

      emit(state.copyWith(
        isLoading: LoadingState.finished,
        user: user,
        action: AuthAction.login,
        isRememberMe: event.rememberMe,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.code == 'user-not-found'
            ? 'Không tìm thấy người dùng với email này.'
            : e.code == 'wrong-password'
                ? 'Mật khẩu không đúng được cung cấp cho người dùng đó.'
                : e.code == 'invalid-email'
                    ? 'Email không hợp lệ được cung cấp.'
                    : e.code,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAuthencationRegisterEvent(
    AuthenticationRegisterEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.isLoading == LoadingState.loading) {
      return;
    }

    emit(state.copyWith(isLoading: LoadingState.loading, error: null));

    final email = event.email.trim();
    final password = event.password.trim();
    final passwordConfirm = event.passwordConfirm.trim();
    final name = event.name.trim();

    if (name.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Tên không được để trống.",
      ));
      return;
    }

    if (email.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Email không được để trống.",
      ));
      return;
    }

    if (!validateEmail(email)) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Định dạng email không hợp lệ.",
      ));
      return;
    }

    if (password.isEmpty || passwordConfirm.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Mật khẩu không được để trống.",
      ));
      return;
    }

    if (password != passwordConfirm) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Mật khẩu không khớp.",
      ));
      return;
    }

    try {
      final registerUseCase = getIt<RegisterUseCase>();
      UserEntity user = await registerUseCase(email, password);

      // Cập nhật tên người dùng
      final updateDisplayNameUseCase = getIt<UpdateDisplayNameUseCase>();
      await updateDisplayNameUseCase(name);
      user = user.copyWith(name: name);

      emit(state.copyWith(
        isLoading: LoadingState.finished,
        user: user,
        action: AuthAction.register,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.code == 'weak-password'
            ? 'Mật khẩu cung cấp quá yếu.'
            : e.code == 'email-already-in-use'
                ? 'Tài khoản đã tồn tại với email này.'
                : e.code == 'invalid-email'
                    ? 'Email cung cấp không hợp lệ.'
                    : 'Đã xảy ra lỗi. Vui lòng thử lại.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: 'Đã xảy ra lỗi. Vui lòng thử lại.',
      ));
    }
  }

  Future<void> _onAuthencationForgotPasswordEvent(
    AuthenticationForgotPasswordEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.isLoading == LoadingState.loading) {
      return;
    }

    final email = event.email.trim();

    if (email.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Email không được để trống.",
        action: AuthAction.forgotPassword,
      ));
      return;
    }

    if (!validateEmail(email)) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Email không đúng định dạng.",
        action: AuthAction.forgotPassword,
      ));
      return;
    }

    emit(state.copyWith(
      isLoading: LoadingState.loading,
      error: null,
      action: AuthAction.forgotPassword,
    ));

    try {
      // Kiểm tra xem email có tồn tại trong hệ thống không
      final methods =
          // ignore: deprecated_member_use
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.isEmpty) {
        emit(state.copyWith(
          isLoading: LoadingState.error,
          error: "Không tìm thấy tài khoản với email này.",
          action: AuthAction.forgotPassword,
        ));
        return;
      }

      // Nếu email tồn tại, gửi email đặt lại mật khẩu
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      emit(state.copyWith(
        isLoading: LoadingState.finished,
        action: AuthAction.forgotPassword,
      ));
    } on FirebaseAuthException catch (e) {
      String message = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      if (e.code == 'invalid-email') {
        message = 'Email không hợp lệ.';
      } else if (e.code == 'too-many-requests') {
        message = 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
      }
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: message,
        action: AuthAction.forgotPassword,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: 'Đã xảy ra lỗi. Vui lòng thử lại.',
        action: AuthAction.forgotPassword,
      ));
    }
  }

  Future<void> _onAuthenticationGoogleLoginEvent(
    AuthenticationGoogleLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.isLoading == LoadingState.loading) {
      return;
    }

    emit(state.copyWith(isLoading: LoadingState.loading, error: null));

    try {
      final googleLoginUseCase = getIt<LoginWithGoogleUsecase>();
      final user = await googleLoginUseCase();

      // Lưu trạng thái Remember Me cho đăng nhập Google
      if (event.rememberMe) {
        await _saveRememberMeStatusUseCase(true);
        // Lưu thông tin đăng nhập Google - lưu ý rằng chúng ta chỉ lưu email
        // vì đăng nhập Google không sử dụng mật khẩu thông thường
        await _saveUserCredentialsUseCase(user.email, "google_login");
        print("Đã lưu thông tin đăng nhập Google: ${user.email}");
      } else {
        // Ngay cả khi không tích Remember me, vẫn cần đặt lại thông tin cũ nếu có
        await _saveRememberMeStatusUseCase(false);
        await _saveUserCredentialsUseCase('', '');
      }

      emit(state.copyWith(
        isLoading: LoadingState.finished,
        user: user,
        action: AuthAction.login,
        isRememberMe: event.rememberMe,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.code == 'account-exists-with-different-credential'
            ? 'Tài khoản đã tồn tại với một thông tin xác thực khác.'
            : e.code == 'invalid-credential'
                ? 'Thông tin xác thực cung cấp không hợp lệ.'
                : 'Đã xảy ra lỗi. Vui lòng thử lại.',
      ));
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: 'Đã xảy ra lỗi. Vui lòng thử lại.',
      ));
    }
  }

  Future<void> _onLikeMovieEvent(
    LikeMovieEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(
        error: 'Người dùng chưa đăng nhập.',
      ));
      return;
    }

    final updatedLikedMovies = List<String>.from(state.user!.likedMovies);
    if (updatedLikedMovies.contains(event.movieId)) {
      updatedLikedMovies.remove(event.movieId);
    } else {
      updatedLikedMovies.add(event.movieId);
    }

    final updatedUser = UserModel(
      uid: state.user!.uid,
      email: state.user!.email,
      name: state.user!.name,
      avatar: state.user!.avatar,
      subscriptionPlan: state.user!.subscriptionPlan,
      likedMovies: updatedLikedMovies,
      watchedMovies: state.user!.watchedMovies,
    );

    try {
      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);
      emit(state.copyWith(user: updatedUser));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateWatchedMovieEvent(
    UpdateWatchedMovieEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(error: 'Người dùng chưa đăng nhập.'));
      return;
    }

    final updatedWatchedMovies =
        List<WatchedMovie>.from(state.user!.watchedMovies);
    final movieIndex =
        updatedWatchedMovies.indexWhere((m) => m.movieId == event.movieId);

    WatchedMovie updatedMovie;

    if (movieIndex == -1) {
      // Create new movie entry
      updatedMovie = WatchedMovie(
        movieId: event.movieId,
        isSeries: event.isSeries,
        name: event.name,
        thumbUrl: event.thumbUrl,
        episodeTotal: event.episodeTotal,
        time: event.time,
        watchedEpisodes: {
          event.episode: WatchedEpisode(
            duration: event.watchedDuration,
            serverName: event.serverName,
          ),
        },
      );
      updatedWatchedMovies.add(updatedMovie);
    } else {
      // Update existing movie
      final existingMovie = updatedWatchedMovies[movieIndex];
      final updatedEpisodes =
          Map<int, WatchedEpisode>.from(existingMovie.watchedEpisodes);
      updatedEpisodes[event.episode] = WatchedEpisode(
        duration: event.watchedDuration,
        serverName: event.serverName,
      );

      updatedMovie = WatchedMovie(
        movieId: existingMovie.movieId,
        isSeries: existingMovie.isSeries,
        name: existingMovie.name,
        thumbUrl: existingMovie.thumbUrl,
        episodeTotal: existingMovie.episodeTotal,
        watchedEpisodes: updatedEpisodes,
        time: existingMovie.time,
      );
      updatedWatchedMovies[movieIndex] = updatedMovie;
    }

    // Move the updated movie to the top of the list
    updatedWatchedMovies.removeWhere((m) => m.movieId == updatedMovie.movieId);
    updatedWatchedMovies.insert(0, updatedMovie);

    final updatedUser = UserModel(
      uid: state.user!.uid,
      email: state.user!.email,
      name: state.user!.name,
      avatar: state.user!.avatar,
      subscriptionPlan: state.user!.subscriptionPlan,
      likedMovies: state.user!.likedMovies,
      watchedMovies: updatedWatchedMovies,
    );

    try {
      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);
      emit(state.copyWith(user: updatedUser));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // Future<void> _onUpdateSubscriptionPlanEvent(
  //   UpdateSubscriptionPlanEvent event,
  //   Emitter<AuthenticationState> emit,
  // ) async {
  //   if (state.user == null) {
  //     emit(state.copyWith(
  //       error: 'Người dùng chưa đăng nhập.',
  //     ));
  //     return;
  //   }

  //   final updatedUser = UserModel(
  //     uid: state.user!.uid,
  //     email: state.user!.email,
  //     name: state.user!.name,
  //     avatar: state.user!.avatar,
  //     subscriptionPlan: event.subscriptionPlan,
  //     likedMovies: state.user!.likedMovies,
  //     watchedMovies: state.user!.watchedMovies,
  //   );

  //   try {
  //     final updateUserUseCase = getIt<UpdateUserUseCase>();
  //     await updateUserUseCase(updatedUser);
  //     emit(state.copyWith(
  //       user: updatedUser,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(error: e.toString()));
  //   }
  // }

  Future<void> _onUpdateGenresEvent(
    UpdateGenresEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(
        error: 'Người dùng chưa đăng nhập.',
      ));
      return;
    }

    final updatedUser = UserModel(
      uid: state.user!.uid,
      email: state.user!.email,
      name: state.user!.name,
      avatar: state.user!.avatar,
      subscriptionPlan: state.user!.subscriptionPlan,
      likedMovies: state.user!.likedMovies,
      watchedMovies: state.user!.watchedMovies,
      likedGenres: event.genres,
    );

    try {
      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);
      emit(state.copyWith(
        user: updatedUser,
        action: AuthAction.none,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _saveRememberMeStatusUseCase(false);
    await _saveUserCredentialsUseCase('', '');

    // Đặt lại trạng thái
    emit(AuthenticationState.init());
  }

  Future<void> _onRemoveWatchedMovieEvent(
    RemoveWatchedMovieEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(
        error: 'Người dùng chưa đăng nhập.',
      ));
      return;
    }

    final updatedWatchedMovies =
        List<WatchedMovie>.from(state.user!.watchedMovies)
          ..removeWhere((movie) => movie.movieId == event.movieId);

    final updatedUser = UserModel(
      uid: state.user!.uid,
      email: state.user!.email,
      name: state.user!.name,
      avatar: state.user!.avatar,
      subscriptionPlan: state.user!.subscriptionPlan,
      likedMovies: state.user!.likedMovies,
      watchedMovies: updatedWatchedMovies,
      likedGenres: state.user!.likedGenres,
    );

    try {
      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);
      emit(state.copyWith(
        user: updatedUser,
        action: AuthAction.none,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
