import '../../../domain/entities/category.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<Category> categories;

  const CategorySuccess({required this.categories});
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});
}
