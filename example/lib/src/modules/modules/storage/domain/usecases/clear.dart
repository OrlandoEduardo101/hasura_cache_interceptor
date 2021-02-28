import 'package:dartz/dartz.dart';
import '../errors/erros.dart';
import '../repositories/storage_repository.dart';

abstract class IClear {
  Future<Either<DeleteError, Unit>> call();
}

class Clear implements IClear {
  final IStorageRepository _repository;

  Clear(this._repository);

  @override
  Future<Either<DeleteError, Unit>> call() async {
    // ignore: unnecessary_null_comparison
    return await _repository.clear();
  }
}
