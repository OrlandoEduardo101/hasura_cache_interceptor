# hasura_cache_interceptor

Hasura Connect Cache Interceptor 

## How to use
pubspec.yaml
```yaml
dependencies:
  hasura_connect: <last version>
  hasura_cache_interceptor: <last version>
```

### SharedPreferences Cache
```dart
import 'package:hasura_cache_interceptor/hasura_hive_cache_interceptor.dart';

final storage = SharedPreferencesStorageService();
final cacheInterceptor = CacheInterceptor(storage);
final hasura = HasuraConnect(
  "<your hasura url>",
  interceptors: [cacheInterceptor],
  httpClient: httpClient,
)
```

### Hive Cache
```dart
import 'package:hasura_cache_interceptor/hasura_hive_cache_interceptor.dart';

final storage = HiveStorageService();
final cacheInterceptor = CacheInterceptor(storage);
final hasura = HasuraConnect(
  "<your hasura url>",
  interceptors: [cacheInterceptor],
  httpClient: httpClient,
)
```

### In Memory Cache (without persistence)
```dart
import 'package:hasura_cache_interceptor/hasura_hive_cache_interceptor.dart';

final storage = MemoryStorageService();
final cacheInterceptor = CacheInterceptor(storage);
final hasura = HasuraConnect(
  "<your hasura url>",
  interceptors: [cacheInterceptor],
  httpClient: httpClient,
)
```