import 'package:hasura_connect/hasura_connect.dart';
import '../../../modules/storage/presenter/storage_controller.dart';
import '../interceptors/cache_interceptor.dart';


class CustomHasuraConnect {
  final String url;

  CustomHasuraConnect(this.url);
  HasuraConnect getConnect(StorageController controller) {
    return HasuraConnect(
      url,
      interceptors: [
        CacheInterceptor(controller),
        LogInterceptor(),
        //HiveCacheInterceptor(),
      ],
      headers: {},
    );
  }
}