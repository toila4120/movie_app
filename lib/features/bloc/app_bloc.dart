import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/authencation/data/model/user_model.dart';
import 'package:movie_app/features/authencation/domain/usecase/get_user_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState.init()) {
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<FetchUserEvent>(_onFetchUserEvent);
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
}
