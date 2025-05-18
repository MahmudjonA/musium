import 'package:musium/features/home/domain/entities/genres.dart';

class GenreModel extends Genre {
  GenreModel({
    required super.id,
    required super.genre,
    required super.imagePath,
    required super.color,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'],
      genre: json['genre'],
      imagePath: json['image_path'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'genre': genre, 'image_path': imagePath, 'color': color};
  }
}
