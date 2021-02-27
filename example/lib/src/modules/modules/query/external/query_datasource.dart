import 'package:example/src/modules/modules/query/domain/entities/product_entity.dart';
import 'package:example/src/modules/modules/query/infra/datasource/query_datasources.dart';
import 'package:hasura_connect/hasura_connect.dart';

class QueryDatasource implements IQueryDatasource {
  // ignore: non_constant_identifier_names
  final HasuraConnect hasura_connect;
  QueryDatasource(this.hasura_connect);
  @override
  Future<List<ProductEntity>> getProducts() async {
    var response;
    var queryDoc = r'''
          query MyQuery {
        new_schema_products(order_by: {produc_name: asc}) {
          bar_code
          created_at
          id
          produc_name
          provider_id
          updated_at
        }
      }
    ''';
    try {
      response = await hasura_connect.query(queryDoc);
    } catch (e) {
      throw Exception('ErrorConnection: $e');
    }

    List<ProductEntity> listProducts = [];

    try {
      for (var item in response['data']['new_schema_products']) {
      listProducts.add(ProductEntity.fromMap(item));
    }
    } catch (e) {
      throw Exception('Error generate list: $e');
    }

    return listProducts;
  }
}
