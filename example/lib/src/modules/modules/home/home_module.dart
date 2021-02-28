import 'package:example/src/modules/modules/home/home_controller.dart';
import 'package:example/src/modules/modules/query/query_module.dart';
import 'package:example/src/modules/modules/subscription/subscription_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => HomeController()),
      ];

  @override
  final List<ModularRoute> routes = [
        ChildRoute(Modular.initialRoute, child: (_, args) => HomePage()),
        ModuleRoute('/query', module: QueryModule()),
        ModuleRoute('/subscription', module: SubscriptionModule()),
      ];

}
