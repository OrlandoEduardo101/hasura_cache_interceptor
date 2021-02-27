import 'package:example/src/modules/modules/query/domain/usecases/get_products.dart';
import 'package:example/src/modules/modules/query/external/query_datasource.dart';
import 'package:example/src/modules/modules/query/infra/repositories/query_repository.dart';
import 'package:example/src/modules/modules/query/presenter/list_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/list_page.dart';

class QueryModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => GetProducts(i())),
        Bind((i) => QueryRepository(i())),
        Bind((i) => QueryDatasource(i())),
        Bind((i) => ListController(i())),
      ];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => ListPage()),
      ];

}
