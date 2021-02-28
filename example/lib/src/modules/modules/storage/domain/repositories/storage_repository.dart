import 'package:dartz/dartz.dart';
import '../errors/erros.dart';

abstract class IStorageRepository {
  Future<Either<DeleteError, Unit>> delete(String key);
  Future<Either<DeleteError, Unit>> clear();
  Future<Either<PutError, Unit>> put(String key, Map value);
  Future<Either<UpdateError, Unit>> update(String key, Map value);
  Future<Either<ReadError, Map>> read(String key);
  Future<Either<ReadError, bool>> containsKey(String key);
}