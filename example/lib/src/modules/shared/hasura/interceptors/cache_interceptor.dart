import 'package:hasura_connect/hasura_connect.dart';
import 'package:uuid/uuid.dart';
import '../../../modules/storage/presenter/interfaces/storage_controller.dart';

class CacheInterceptor implements Interceptor {
  final IStorageController _storage;
  static const NAMESPACE_KEY = 'b34a217c-f439-50b1-b1c1-4e491a72d05f';
  CacheInterceptor(this._storage);

  @override
  Future<void>? onConnected(HasuraConnect connect) {}

  @override
  Future<void>? onDisconnected() {}

  @override
  Future? onError(HasuraError error) async {
    bool isConnectionError = [
      'Connection Rejected',
      'Websocket Error',
    ].contains(error.message);

    isConnectionError = isConnectionError ||
        error.message
            .contains('No address associated with hostname, errno = 7');

    final containsCache = await _storage.containsKey(error.request.url + error.request.query.key.toString());
    if (isConnectionError && containsCache) {
      final cachedData = await _storage.read(error.request.url + error.request.query.key.toString());
      return Response(
          data: cachedData, request: error.request, statusCode: 200);
    }
    return error;
  }

  @override
  Future? onRequest(Request request) async {
    return request;
  }

  @override
  Future? onResponse(Response data) async {
    _storage.put(data.request.url + data.request.query.key.toString(), data.data);
    return data;
  }

  @override
  Future<void>? onSubscription(Request request, Snapshot snapshot) async {
    final key = Uuid().v5(NAMESPACE_KEY, '${request.url}: ${snapshot.query}');
    final containsCache = await _storage.containsKey(key);

    if (containsCache) {
      final cachedData = await _storage.read(key);
      snapshot.add(cachedData);
    }
    final subscription =
        snapshot.listen((data) => _updateSubscriptionCache(key, data));
    snapshot.listen((_) {}, onDone: subscription.cancel);
    // snapshot = Snapshot(
    //   query: snapshot.query,
    //   changeVariablesF: snapshot.changeVariablesF,
    //   closeConnection: snapshot.closeConnection,
    //   rootStream: snapshot.asyncMap((data) async => _updateSubscriptionCache(key, data)),
    // );
  }

  Future? _updateSubscriptionCache(String key, dynamic data) async {
    final cachedData = await _storage.read(key);
    if (cachedData != data) {
      await _storage.put(key, data);
    }
    return data;
  }

  @override
  Future<void>? onTryAgain(HasuraConnect connect) {}
}
