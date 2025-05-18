import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musium/features/home/domain/use_cases/category_use_case.dart';
import '../category_event.dart';
import 'category_state.dart';

class GetCategoriesBloc extends Bloc<HomeEvent, CategoryState> {
  final CategoryUseCase getCategoriesUseCase;

  GetCategoriesBloc(this.getCategoriesUseCase) : super(CategoryInitial()) {
    on<GetCategoriesEvent>(onGetCategories);
  }

  Future<void> onGetCategories(event, emit) async {
    emit(CategoryLoading());
    try {
      final category = await getCategoriesUseCase();
      emit(CategorySuccess(categories: category));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
