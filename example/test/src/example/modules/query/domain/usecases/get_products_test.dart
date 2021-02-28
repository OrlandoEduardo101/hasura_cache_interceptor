import 'package:dartz/dartz.dart';
import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:example/src/modules/modules/query/domain/repositories/query_repository.dart';
import 'package:example/src/modules/modules/query/domain/usecases/get_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RepositoryMock extends Mock implements IQueryRepository {}

main() {
  var _repository = RepositoryMock();
  var usecase = GetProducts(_repository);
  var product = ProductEntity();

  test('must return a list of products', () async {
    when(_repository).calls(#getProducts).thenAnswer((_) async => Right<Exception, List<ProductEntity>>([product, product]));
    var result = await usecase();
    expect(result.fold((l) => l, (r) => r), isA<List<ProductEntity>>());
  });

  test('must return a exception when get products', () async {
    when(_repository).calls(#getProducts).thenAnswer((_) async => Left<Exception, List<ProductEntity>>(Exception()));
    var result = await usecase();
    expect(result.fold((l) => l, (r) => r), isA<Exception>());
  });
}
