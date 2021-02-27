import 'package:dartz/dartz.dart';
import '../errors/erros.dart';
import '../repositories/storage_repository.dart';

abstract class IPut {
  Future<Either<PutError, Unit>> call(String key, Map value);
}

class Put implements IPut {
  final IStorageRepository _repository;

  Put(this._repository);

  @override
  Future<Either<PutError, Unit>> call(String key, Map value) async {
    // ignore: unnecessary_null_comparison
    if (key == null || key.isEmpty) {
      return Left(PutError(message: 'Invalid key'));
    }
    return await _repository.put(key, value);
  }
}
