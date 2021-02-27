import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/errors/erros.dart';
import '../../infra/datasource/storage_datasource.dart';

class StorageDatasource implements IStorageDatasource {
  Completer<Box> completer = Completer<Box>();
  final HiveInterface _hive;

  StorageDatasource(this._hive) {
    _init();
  }

  _init() async {
    await _hive.initFlutter();
    final box = await _hive.openBox('authLocalStorageService');
    completer.complete(box);
  }

  @override
  Future<Unit> delete(String key) async {
    var box = await completer.future;
    try {
      await box.delete(key);
      return unit;
    } catch (e) {
      throw DeleteError(message: 'Error delete file: $e');
    }
  }

  @override
  Future<Unit> put(String key, Map value) async {
    var box = await completer.future;
    try {
      await box.put(key, value);
      return unit;
    } catch (e) {
      throw PutError(message: 'Error save file: $e');
    }
  }

  @override
  Future<Map> read(String key) async {
    var box = await completer.future;
    try {
      Map response = {};
      if (box.containsKey(key)) {
        response = box.get(key);
      }
      // ignore: unnecessary_null_comparison
      if (response == null) {
        return {};
      }
      return response;
    } catch (e) {
      throw ReadError(message: 'Error read file: $e');
    }
  }

  @override
  Future<Unit> update(String key, Map value) async {
    var box = await completer.future;
    try {
      await box.put(key, value);
      return unit;
    } catch (e) {
      throw PutError(message: 'Error update file: $e');
    }
  }

  @override
  Future<Unit> clear() async {
    var box = await completer.future;
    try {
      await box.clear();
      return unit;
    } catch (e) {
      throw DeleteError(message: 'Error delete file: $e');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    var box = await completer.future;
    try {
      return await box.containsKey(key);
    } catch (e) {
      throw ReadError(message: 'Error read key: $e');
    }
  }
}
