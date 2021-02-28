

import 'package:dartz/dartz.dart';

import '../errors/erros.dart';
import '../repositories/storage_repository.dart';

abstract class IUpdate {
  Future<Either<UpdateError, Unit>> call(String key, Map value);
}

class Update implements IUpdate {
  final IStorageRepository _repository;

  Update(this._repository);

  @override
  Future<Either<UpdateError, Unit>> call(String key, Map value) async {
    // ignore: unnecessary_null_comparison
    if (key == null || key.isEmpty) {
      return Left(UpdateError(message: 'Invalid key'));
    }
    return await _repository.update(key, value);
  }
}