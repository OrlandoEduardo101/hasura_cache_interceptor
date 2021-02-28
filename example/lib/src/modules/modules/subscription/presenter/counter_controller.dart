import 'package:example/src/modules/modules/subscription/domain/entities/counter_entity.dart';
import 'package:example/src/modules/modules/subscription/domain/usecases/get_counter_stream.dart';
import 'package:example/src/modules/modules/subscription/domain/usecases/update_counter.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:hasura_connect/hasura_connect.dart';

class CounterController extends NotifierStore<Exception, int> {
  CounterController(this._getCounterStream, this._updateCounter) : super(0) {
    getData();
  }
  final IGetCounterStream _getCounterStream;
  final IUpdateCounter _updateCounter;

  //CounterEntity counterEntity = CounterEntity();

  late Snapshot<CounterEntity> snapshot;

  Future getData() async {
    var result = await _getCounterStream();
    result.fold((l) => setError(Exception()), (r) => snapshot = r);
    snapshot.listen((event) {
      update(event.counter!);
    });
  }

  Future<void> increment() async {
    int value = state;
    value++;
    CounterEntity counter = await snapshot.first;
    Future.delayed(Duration(milliseconds: 500)).whenComplete(
        () async => _updateCounter(counter.copyWith(counter: value)));
  }
}
