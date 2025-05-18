import 'dart:io';

import 'package:musium/features/home/domain/repositories/home_repo.dart';

class AddTrackToStorageUseCase {
  final HomeRepo homeRepo;

  AddTrackToStorageUseCase(this.homeRepo);

  Future<Map<String, dynamic>> call(File file) async {
    return await homeRepo.addTrackToStorage(file);
  }
}
