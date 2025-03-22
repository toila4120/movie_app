import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/app_log.dart';
import 'package:movie_app/features/categories/domain/usecase/get_all_categories_use_case.dart';
import 'package:movie_app/injection_container.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesState.init()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(loadingState: LoadingState.loading));
    try {
      final getAllCategories = getIt<GetAllCategories>();
      final categories = await getAllCategories();
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        categories: categories,
      ));
    } catch (e) {
      AppLog.debug(e.toString());
      emit(state.copyWith(
        loadingState: LoadingState.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
