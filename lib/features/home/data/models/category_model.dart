import 'package:musium/features/home/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.title,
    required super.image,
    required super.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      image: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'image_path': image};
  }
}
