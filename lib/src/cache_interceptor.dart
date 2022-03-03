import 'package:hasura_connect/hasura_connect.dart';
import 'package:uuid/uuid.dart';

import 'services/storage_service_interface.dart';

class CacheInterceptor implements Interceptor {
  static const NAMESPACE_KEY = "b34a217c-f439-50b1-b1c1-4e491a72d05f";
  final IStorageService _storage;
  CacheInterceptor(this._storage);

  Future<void> clearAllCache() async => await _storage.clear();

  @override
  Future<void>? onConnected(HasuraConnect connect) async {}

  @override
  Future<void>? onDisconnected() async {}

  @override
  Future? onError(HasuraError error, HasuraConnect connect) async {
    bool isConnectionError = [
      "Connection Rejected",
      "Websocket Error",
    ].contains(error.message);

    isConnectionError = isConnectionError || error.message.contains('No address associated with hostname, errno = 7');

    String key = generateKey(error.request);
    final containsCache = await _storage.containsKey(key);
    if (isConnectionError && containsCache) {
      final cachedData = await _storage.get(key);
      return Response(data: cachedData, statusCode: 500, request: error.request);
    }
    return error;
  }

  @override
  Future? onRequest(Request request, HasuraConnect connect) async {
    return request;
  }

  @override
  Future? onResponse(Response data, HasuraConnect connect) async {
    String key = generateKey(data.request);
    _storage.put(key, data.data);
    return data;
  }

  @override
  Future<void>? onSubscription(Request request, Snapshot snapshot) async {
    String key = generateKey(request);

    final containsCache = await _storage.containsKey(key);
    if (containsCache) {
      final cachedData = await _storage.get(key);
      snapshot.add(cachedData);
    }
    final subscription = snapshot.listen((data) => _updateSubscriptionCache(key, data));
    snapshot.listen((_) {}, onDone: () => subscription.cancel());
    // snapshot = Snapshot(
    //   query: snapshot.query,
    //   changeVariablesF: snapshot.changeVariablesF,
    //   closeConnection: snapshot.closeConnection,
    //   rootStream: snapshot.asyncMap((data) async => _updateSubscriptionCache(key, data)),
    // );
  }

  Future? _updateSubscriptionCache(String key, dynamic data) async {
    final cachedData = await _storage.get(key);
    if (cachedData != data) {
      await _storage.put(key, data);
    }
    return data;
  }

  String generateKey(Request request) {
    final keyIsNullOrEmpty = request.query.key == null || request.query.key!.isEmpty;
    String key = Uuid().v5(NAMESPACE_KEY, "${request.url}: ${keyIsNullOrEmpty ? request.query : request.query.key}");
    return key;
  }

  @override
  Future<void>? onTryAgain(HasuraConnect connect) async {}
}
