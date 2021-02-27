import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'list_controller.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ListController controller = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query ProductList'),
      ),
      body: ScopedBuilder<ListController, Exception, List>(
        store: controller,
        onError: (context, error) => Center(
          child: ElevatedButton(
              onPressed: controller.getList, child: Text('Try Again')),
        ),
        onLoading: (context) => Center(
          child: CircularProgressIndicator(),
        ),
        onState: (context, state) => ListView.builder(
            itemCount: controller.state.length,
            itemBuilder: (_, index) {
              ProductEntity item = controller.state[index];
              return Card(
                child: ListTile(
                  title: Text('${item.producName}'),
                  subtitle: Text('${item.id}'),
                ),
              );
            }),
      ),
    );
  }
}
