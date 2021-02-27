import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:example/src/modules/modules/query/domain/repositories/query_repository.dart';

abstract class IGetProducts {
  Future<Either<Exception, List<ProductEntity>>> call();
}

class GetProducts implements IGetProducts {
  final IQueryRepository _repository;

  GetProducts(this._repository);
  @override
  Future<Either<Exception, List<ProductEntity>>> call() async {
    return await _repository.getProducts();
  }
}
