import 'package:dartz/dartz.dart';
import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';

abstract class IQueryRepository {
  Future<Either<Exception, List<ProductEntity>>> getProducts();
}