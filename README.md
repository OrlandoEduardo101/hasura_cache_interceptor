# Hasura Connect Cache Interceptor
 

## Implementations [[more]](https://pub.dev/packages?q=dependency%3Ashared_preferences)
### Using Shared Preferences [[shared_preferences_cache_interceptor]](https://pub.dev/packages/shared_preferences)
### Using Hive [[hasura_hive_cache_interceptor]](https://pub.dev/packages/shared_preferences)

## Use Example
pubspec.yaml
```yaml
dependencies:
  hasura_connect: <last version>
  hasura_cache_interceptor: <last version>
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