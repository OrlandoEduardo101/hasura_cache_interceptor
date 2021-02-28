import 'package:dartz/dartz.dart';

import '../../domain/errors/erros.dart';
import '../../domain/repositories/storage_repository.dart';
import '../datasource/storage_datasource.dart';

class StorageRepository implements IStorageRepository {
  final IStorageDatasource _datasource;

  StorageRepository(this._datasource);
  @override
  Future<Either<DeleteError, Unit>> delete(String key) async {
    try {
      return Right(await _datasource.delete(key));
    } catch (e) {
      return Left(DeleteError(message: '$e'));
    }
  }

  @override
  Future<Either<PutError, Unit>> put(String key, Map value) async {
      try {
      return Right(await _datasource.put(key, value));
      } catch (e) {
        return Left(PutError(message: '$e'));
      }
  }

  @override
  Future<Either<ReadError, Map>> read(String key) async {
      try {
      return Right(await _datasource.read(key));
    } catch (e) {
      return Left(ReadError(message: '$e'));
    }
  }

  @override
  Future<Either<UpdateError, Unit>> update(String key, Map value) async {
    try {
      return Right(await _datasource.update(key, value));
      } catch (e) {
        return Left(UpdateError(message: '$e'));
      }
  }

  @override
  Future<Either<DeleteError, Unit>> clear() async {
    try {
      return Right(await _datasource.clear());
    } catch (e) {
      return Left(DeleteError(message: '$e'));
    }
  }

  @override
  Future<Either<ReadError, bool>> containsKey(String key) async {
    try {
      return Right(await _datasource.containsKey(key));
    } catch (e) {
      return Left(ReadError(message: '$e'));
    }
  }
}
