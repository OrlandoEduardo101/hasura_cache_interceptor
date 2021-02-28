import 'package:example/src/modules/modules/subscription/presenter/counter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

class CounterPage extends StatefulWidget {
  CounterPage({Key? key}) : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  CounterController controller = Modular.get();
  @override
  void dispose() {
    controller.snapshot.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query ProductList'),
      ),
      body: ScopedBuilder<CounterController, Exception, int>(
        store: controller,
        onError: (context, error) => Center(
          child: ElevatedButton(
              onPressed: controller.getData, child: Text('Try Again')),
        ),
        onLoading: (context) => Center(
          child: CircularProgressIndicator(),
        ),
        onState: (context, state) => Center(
          child: Text(
            '${controller.state}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
