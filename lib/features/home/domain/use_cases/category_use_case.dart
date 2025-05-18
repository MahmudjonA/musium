import 'package:musium/features/home/domain/entities/category.dart';
import '../repositories/home_repo.dart';

class CategoryUseCase {
  final HomeRepo homeRepo;

  CategoryUseCase(this.homeRepo);

  Future<List<Category>> call() async {
    return await homeRepo.getCategories();
  }
}
