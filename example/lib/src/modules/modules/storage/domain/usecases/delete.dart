import 'package:dartz/dartz.dart';
import '../errors/erros.dart';
import '../repositories/storage_repository.dart';

abstract class IDelete {
  Future<Either<DeleteError, Unit>> call(String key);
}

class Delete implements IDelete {
  final IStorageRepository _repository;

  Delete(this._repository);

  @override
  Future<Either<DeleteError, Unit>> call(String key) async {
    // ignore: unnecessary_null_comparison
    if (key == null || key.isEmpty) {
      return Left(DeleteError(message: 'Invalid key'));
    }
    return await _repository.delete(key);
  }
}
