
import 'package:example/src/modules/modules/subscription/domain/usecases/update_counter.dart';
import 'package:example/src/modules/modules/subscription/infra/repositories/subscription_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'domain/usecases/get_counter_stream.dart';
import 'external/subscription_datasource.dart';
import 'presenter/counter_controller.dart';
import 'presenter/counter_page.dart';

class SubscriptionModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => GetCounterStream(i())),
        Bind((i) => UpdateCounter(i())),
        Bind((i) => SubscriptionRepository(i())),
        Bind((i) => SubscriptionDatasource(i())),
        Bind((i) => CounterController(i(), i())),
      ];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => CounterPage()),
      ];

}