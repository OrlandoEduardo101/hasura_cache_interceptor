import 'package:example/src/modules/modules/query/domain/usecases/get_products.dart';
import 'package:flutter_triple/flutter_triple.dart';

class ListController extends NotifierStore<Exception, List> {
  ListController(this._getProducts) : super([]) {
    getList();
  }

  final IGetProducts _getProducts;

  Future<void> getList() async {
    setLoading(true);
    var result = await _getProducts();
    setLoading(false);
    result.fold((l) => setError(Exception()), (r) => update(r));
  }
}
