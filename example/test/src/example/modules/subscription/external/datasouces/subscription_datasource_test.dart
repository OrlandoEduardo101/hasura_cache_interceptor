import 'dart:convert';
import 'package:example/src/modules/modules/subscription/external/subscription_datasource.dart';
import 'package:hasura_connect/src/domain/models/query.dart';
import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:example/src/modules/modules/query/external/query_datasource.dart';
import 'package:example/src/modules/modules/subscription/domain/entities/counter_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:mocktail/mocktail.dart';

class HasuraMock extends Mock implements HasuraConnect {}

main() {
  // ignore: non_constant_identifier_names
  var hasura_connect = HasuraMock();
  var datasource = SubscriptionDatasource(hasura_connect);
  final requestMock = Request(url: "mock_url", query: Query(document: "query"));
  // ignore: close_sinks
  var snapshotMock = Snapshot(query: requestMock.query);
  var counter = CounterEntity();

  test('must return a product list', () async {
    snapshotMock.add(jsonDecode(response));
    when(hasura_connect)
        .calls(#subscription)
        .thenAnswer((_) async => snapshotMock);

    var result = await datasource.getCounter();
    expect(result, isA<Snapshot<CounterEntity>>());
  });

  test('must return a exception', () async {
    when(hasura_connect).calls(#subscription).thenThrow(Exception());

    var result = datasource.getCounter();
    expect(result, throwsA(isA<Exception>()));
  });

  test('must return a exception', () async {
    when(hasura_connect).calls(#subscription).thenThrow(HasuraRequestError);

    var result = datasource.getCounter();
    expect(result, throwsA(isA<Exception>()));
  });
}

var response = r'''{
  "data": {
    "new_schema_counter": [
      {
        "counter": 0,
        "id": 1
      }
    ]
  }
}
''';
