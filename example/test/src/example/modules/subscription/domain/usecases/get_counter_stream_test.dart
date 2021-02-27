import 'package:dartz/dartz.dart';
import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:example/src/modules/modules/subscription/domain/entities/counter_entity.dart';
import 'package:example/src/modules/modules/subscription/domain/repositories/subscription_repository.dart';
import 'package:example/src/modules/modules/subscription/domain/usecases/get_counter_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hasura_connect/src/domain/models/query.dart';
import 'package:mocktail/mocktail.dart';

class RepositoryMock extends Mock implements ISubscriptionRepository {}

main() {
  var _repository = RepositoryMock();
  var usecase = GetCounterStream(_repository);
  final requestMock = Request(url: "mock_url", query: Query(document: "query"));
  // ignore: close_sinks
  var snapshotMock = Snapshot(query: requestMock.query);
  var counter = CounterEntity();

  test('must return a counter', () async {
    snapshotMock.add(counter);
    when(_repository).calls(#getCounter).thenAnswer((_) async =>
        Right<Exception, Snapshot<CounterEntity>>(snapshotMock.map((event) => event)));
    var result = await usecase();
    expect(result.fold((l) => l, (r) => r), isA<Snapshot<CounterEntity>>());
  });

  test('must return a exception when get products', () async {
    when(_repository).calls(#getCounter).thenAnswer(
        (_) async => Left<Exception, Snapshot<CounterEntity>>(Exception()));
    var result = await usecase();
    expect(result.fold((l) => l, (r) => r), isA<Exception>());
  });
}
