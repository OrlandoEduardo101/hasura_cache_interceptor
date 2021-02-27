import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

import 'domain/repositories/storage_repository.dart';
import 'domain/usecases/clear.dart';
import 'domain/usecases/contains_key.dart';
import 'domain/usecases/delete.dart';
import 'domain/usecases/put.dart';
import 'domain/usecases/read.dart';
import 'domain/usecases/update.dart';
import 'external/datasources/storage_datasource.dart';
import 'infra/datasource/storage_datasource.dart';
import 'infra/repositories/storage_repository.dart';
import 'presenter/interfaces/storage_controller.dart';
import 'presenter/storage_controller.dart';

class StorageModule extends Module {

  static List<Bind> exports = [
        Bind<HiveInterface>((i) => Hive),
        Bind<IPut>((i) => Put(i())),
        Bind<IRead>((i) => Read(i())),
        Bind<IContainsKey>((i) => ContainsKey(i())),
        Bind<IUpdate>((i) => Update(i())),
        Bind<IDelete>((i) => Delete(i())),
        Bind<IClear>((i) => Clear(i())),
        Bind<IStorageRepository>((i) => StorageRepository(i())),
        Bind<IStorageDatasource>((i) => StorageDatasource(i())),
        Bind<IStorageController>((i) => StorageController(i(), i(), i(), i(), i(), i())),
  ];

  @override
  List<Bind> get binds => [];

  @override
  final List<ModularRoute> routes = [];
}
