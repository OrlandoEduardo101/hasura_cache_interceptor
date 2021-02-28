import 'package:dartz/dartz.dart';

import '../domain/errors/erros.dart';
import '../domain/usecases/clear.dart';
import '../domain/usecases/contains_key.dart';
import '../domain/usecases/delete.dart';
import '../domain/usecases/put.dart';
import '../domain/usecases/read.dart';
import '../domain/usecases/update.dart';
import 'interfaces/storage_controller.dart';

class StorageController implements IStorageController {
  final IPut _put;
  final IRead _read;
  final IDelete _delete;
  final IUpdate _update;
  final IClear _clear;
  final IContainsKey _containsKey;

  StorageController(this._put, this._read, this._delete, this._update, this._clear, this._containsKey);

  @override
  Future<Unit> delete(String key) async {
    var result = await _delete(key);
    return result.fold(
        (l) => throw DeleteError(message: '${l.message}'), (r) => r);
  }

  @override
  Future<Unit> put(String key, Map value) async {
    var result = await _put(key, value);
    return result.fold(
        (l) => throw PutError(message: '${l.message}'), (r) => r);
  }

  @override
  Future<Map> read(String key) async {
    var result = await _read(key);
    return result.fold(
        (l) => throw ReadError(message: '${l.message}'), (r) => r);
  }

  @override
  Future<Unit> update(String key, Map value) async {
    var result = await _update(key, value);
    return result.fold(
        (l) => throw UpdateError(message: '${l.message}'), (r) => r);
  }

  @override
  Future<Unit> clear() async {
    var result = await _clear();
    return result.fold(
        (l) => throw DeleteError(message: '${l.message}'), (r) => r);
  }

  @override
  Future<bool> containsKey(String key) async {
    var result = await _containsKey(key);
    return result.fold(
        (l) => throw ReadError(message: '${l.message}'), (r) => r);
  }
}
