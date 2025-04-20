import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/categories/domain/usecase/get_all_categories_use_case.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_event.dart';
import 'package:movie_app/features/categories/presentation/bloc/categories_state.dart';
import 'package:movie_app/injection_container.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesState.init()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
      FetchCategories event, Emitter<CategoriesState> emit) async {
    emit(
        state.copyWith(loadingState: LoadingState.loading, errorMessage: null));
    try {
      final useCase = getIt<GetAllCategories>();
      final categories = await useCase();
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
