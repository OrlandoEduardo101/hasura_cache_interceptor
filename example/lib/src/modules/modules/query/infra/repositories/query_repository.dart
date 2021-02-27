import 'package:dartz/dartz.dart';
import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:example/src/modules/modules/query/domain/repositories/query_repository.dart';
import 'package:example/src/modules/modules/query/infra/datasource/query_datasources.dart';

class QueryRepository implements IQueryRepository {
  final IQueryDatasource _datasource;

  QueryRepository(this._datasource);
  @override
  Future<Either<Exception, List<ProductEntity>>> getProducts() async {
    try {
      var result = await _datasource.getProducts();
      return Right(result);
    } catch (e) {
      return Left(Exception('DataSourceError: $e'));
    }
  }
}
