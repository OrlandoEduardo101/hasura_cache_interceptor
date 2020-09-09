import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hasura_cache_interceptor/hasura_hive_cache_interceptor.dart';
import 'package:hasura_cache_interceptor/src/cache_interceptor.dart';
import 'package:hasura_cache_interceptor/src/services/storage_service_interface.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockStorageService extends Mock implements IStorageService {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  final storage = MockStorageService();
  final httpClient = MockHttpClient();
  final cacheInterceptor = CacheInterceptor(storage);
  HasuraConnect service;
  setUp(() {
    when(httpClient.close()).thenReturn(() {});
    service = HasuraConnect(
      "https://www.youtube.com/c/flutterando",
      interceptors: [cacheInterceptor],
      httpClient: httpClient,
    );
  });

  tearDown(() async {
    await cacheInterceptor.clearAllCache();
  });

  group("no connection and", () {
    test(" no cache, throws exception", () async {
      final mockResponse = http.Response("", 404);
      when(
        httpClient.post(
          any,
          body: anyNamed("body"),
          headers: anyNamed("headers"),
        ),
      ).thenAnswer((realInvocation) async => mockResponse);

      when(storage.containsKey(any))
          .thenAnswer((realInvocation) async => false);

      expect(service.query("query"), throwsException);
    });

    test(" have cache, return cache", () async {
      final cache = {"cache_mock_key": "cache_mock_value"};
      final mockResponse = http.Response("", 404);
      when(
        httpClient.post(
          any,
          body: anyNamed("body"),
          headers: anyNamed("headers"),
        ),
      ).thenAnswer((realInvocation) async => mockResponse);
      when(storage.containsKey(any)).thenAnswer((realInvocation) async => true);
      when(storage.get(any)).thenAnswer((realInvocation) async => cache);

      expect(await service.query("query"), cache);
    });
  });

  group("have connection and", () {
    test("no cache, return real response", () async {
      final realResponse = {"mock_key": "mock_value"};

      when(httpClient.post(
        any,
        body: anyNamed("body"),
        headers: anyNamed("headers"),
      )).thenAnswer(
        (realInvocation) async {
          return http.Response(jsonEncode(realResponse), 200);
        },
      );
      when(storage.containsKey(any))
          .thenAnswer((realInvocation) async => false);

      expect(await service.query("query"), realResponse);
    });

    test("have cache, return real response", () async {
      final realResponse = {"mock_key": "mock_value"};
      final cache = {"cache_mock_key": "cache_mock_value"};

      when(
        httpClient.post(
          any,
          body: anyNamed("body"),
          headers: anyNamed("headers"),
        ),
      ).thenAnswer(
        (realInvocation) async => http.Response(jsonEncode(realResponse), 200),
      );
      when(storage.containsKey(any)).thenAnswer((realInvocation) async => true);
      when(storage.get(any)).thenAnswer((realInvocation) async => cache);

      expect(await service.query("query"), realResponse);
    });
  });
}
