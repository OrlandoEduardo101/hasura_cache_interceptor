import 'package:hasura_connect/hasura_connect.dart';
import 'package:uuid/uuid.dart';

import 'services/storage_service_interface.dart';

class CacheInterceptor implements Interceptor {
  final IStorageService _storage;
  CacheInterceptor(this._storage);

  Future<void> clearAllCache() async => await _storage.clear();

  @override
  Future<void> onConnected(HasuraConnect connect) async {}

  @override
  Future<void> onDisconnected() async {}

  @override
  Future onError(HasuraError error) async {
    final isConnectionError = [
      "Connection Rejected",
      "Websocket Error",
    ].contains(error.message);

    final containsCache = await _storage.containsKey(error.request.url);
    if (isConnectionError && containsCache) {
      final cachedData = await _storage.get(error.request.url);
      return Response(data: cachedData, statusCode: 500, request: error.request);
    }
    return error;
  }

  @override
  Future onRequest(Request request) async {
    return request;
  }

  @override
  Future onResponse(Response data) async {
    _storage.put(data.request.url, data.data);
    return data;
  }

  @override
  Future<void> onSubscription(Request request, Snapshot snapshot) async {
    final key = Uuid().v5(request.url, snapshot.query.toString());
    final containsCache = await _storage.containsKey(key);

    if (containsCache) {
      final cachedData = await _storage.get(key);
      snapshot.add(cachedData);
    }
    snapshot = snapshot
        .asyncMap((data) async => _updateSubscriptionCache(key, data));
  }

  Future _updateSubscriptionCache(String key, dynamic data) async {
    final cachedData = await _storage.get(key);
    if (cachedData != data) {
      await _storage.put(key, data);
    }
    return data;
  }

  @override
  Future<void> onTryAgain(HasuraConnect connect) async {}
}
