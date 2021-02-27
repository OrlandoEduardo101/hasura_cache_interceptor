import 'dart:convert';

import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:example/src/modules/modules/query/external/query_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:mocktail/mocktail.dart';

class HasuraMock extends Mock implements HasuraConnect {}

main() {
  // ignore: non_constant_identifier_names
  var hasura_connect = HasuraMock();
  var datasource = QueryDatasource(hasura_connect);
  test('must return a product list', () async {
    when(hasura_connect)
        .calls(#query)
        .thenAnswer((_) async => jsonDecode(response));

    var result = await datasource.getProducts();
    expect(result, isA<List<ProductEntity>>());
  });

  test('must return a exception', () async {
    when(hasura_connect).calls(#query).thenThrow(Exception());

    var result = datasource.getProducts();
    expect(result, throwsA(isA<Exception>()));
  });

  test('must return a exception', () async {
    when(hasura_connect).calls(#query).thenThrow(HasuraRequestError);

    var result = datasource.getProducts();
    expect(result, throwsA(isA<Exception>()));
  });
}

var response = r'''{
  "data": {
    "new_schema_products": [
      {
        "bar_code": "123123",
        "created_at": "2020-10-11T23:11:21.095639+00:00",
        "id": "ff36b683-849e-4f98-beb6-978a939c7175",
        "produc_name": "qeqweqwe",
        "provider_id": 2,
        "updated_at": "2020-10-11T23:11:21.095639+00:00"
      },
      {
        "bar_code": "123123",
        "created_at": "2020-10-11T23:11:26.909275+00:00",
        "id": "f5aeeb18-0a88-44c1-ba3b-1ee3adfb1744",
        "produc_name": "qeqweqwe",
        "provider_id": 1,
        "updated_at": "2020-10-11T23:11:26.909275+00:00"
      },
      {
        "bar_code": "123123",
        "created_at": "2020-10-11T23:11:34.214151+00:00",
        "id": "9dc9ab19-f9a0-46c4-8765-6ebde7ae5bf7",
        "produc_name": "qeqweqwe",
        "provider_id": 3,
        "updated_at": "2020-10-11T23:11:34.214151+00:00"
      },
      {
        "bar_code": "1231232",
        "created_at": "2020-10-11T23:11:36.429585+00:00",
        "id": "10dedc25-2f42-4b48-8e45-6d7634a30a00",
        "produc_name": "qeqweqwe",
        "provider_id": 3,
        "updated_at": "2020-10-11T23:11:36.429585+00:00"
      },
      {
        "bar_code": "5555",
        "created_at": "2020-10-07T16:39:10.47066+00:00",
        "id": "cf7126aa-c5b2-4500-9fb9-bd9d4f98acc4",
        "produc_name": "testeste",
        "provider_id": 5,
        "updated_at": "2020-10-07T16:39:10.47066+00:00"
      },
      {
        "bar_code": "5555",
        "created_at": "2020-10-07T16:39:18.11566+00:00",
        "id": "60a5d207-7c9d-4108-9c22-4d5b4d408dc2",
        "produc_name": "testeste",
        "provider_id": 2,
        "updated_at": "2020-10-07T16:39:18.11566+00:00"
      }
    ]
  }
}
''';
