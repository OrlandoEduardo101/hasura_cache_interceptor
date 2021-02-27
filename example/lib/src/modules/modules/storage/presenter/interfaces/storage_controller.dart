import 'package:dartz/dartz.dart';

abstract class IStorageController {
  Future<Unit> delete(String key);
  Future<Unit> clear();
  Future<Unit> put(String key, Map value);
  Future<Unit> update(String key, Map value);
  Future<Map> read(String key);
  Future<bool> containsKey(String key);
}