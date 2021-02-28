import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:example/src/modules/modules/subscription/domain/entities/counter_entity.dart';
import 'package:example/src/modules/modules/subscription/infra/datasource/subscription_datasources.dart';
import 'package:example/src/modules/modules/subscription/infra/repositories/subscription_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hasura_connect/src/domain/models/query.dart';

class DatasourceMock extends Mock implements ISubscriptionDatasource {}

main() {
  var _datasource = DatasourceMock();
  var repository = SubscriptionRepository(_datasource);
  final requestMock = Request(url: "mock_url", query: Query(document: "query"));
  // ignore: close_sinks
  var snapshotMock = Snapshot(query: requestMock.query);
  var counter = CounterEntity();

  test('must return a counter', () async {
    snapshotMock.add(counter);
    when(_datasource).calls(#getCounter).thenAnswer((_) async => snapshotMock.map((event) => event as CounterEntity));
    var result = await repository.getCounter();
    expect(result.fold((l) => l, (r) => r), isA<Snapshot<CounterEntity>>());
  });

  test('must return a left error list', () async {
    when(_datasource).calls(#getCounter).thenThrow(Exception());
    var result = await repository.getCounter();
    expect(result.fold((l) => l, (r) => r), isA<Exception>());
  });
}
