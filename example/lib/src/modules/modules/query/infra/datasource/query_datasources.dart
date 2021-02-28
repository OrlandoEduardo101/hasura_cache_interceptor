import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';

abstract class IQueryDatasource {
  Future<List<ProductEntity>> getProducts();
}