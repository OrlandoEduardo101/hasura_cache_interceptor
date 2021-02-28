import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:example/src/modules/modules/query/infra/datasource/query_datasources.dart';
import 'package:example/src/modules/modules/query/infra/repositories/query_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DatasourceMock extends Mock implements IQueryDatasource {}

main() {
  var _datasource = DatasourceMock();
  var repository = QueryRepository(_datasource);
  var product = ProductEntity();

  test('must return a right list', () async {
    when(_datasource).calls(#getProducts).thenAnswer((_) async => [product]);
    var result = await repository.getProducts();
    expect(result.fold((l) => l, (r) => r), isA<List<ProductEntity>>());
  });

  test('must return a right list', () async {
    when(_datasource).calls(#getProducts).thenThrow(Exception());
    var result = await repository.getProducts();
    expect(result.fold((l) => l, (r) => r), isA<Exception>());
  });
}
