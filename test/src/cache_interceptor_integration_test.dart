import 'dart:convert';
import 'package:hasura_cache_interceptor/hasura_cache_interceptor.dart';
import 'package:hasura_cache_interceptor/src/cache_interceptor.dart';
import 'package:hasura_cache_interceptor/src/services/storage_service_interface.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageService extends Mock implements IStorageService {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  final storage = MockStorageService();
  final httpClient = MockHttpClient();
  final cacheInterceptor = CacheInterceptor(storage);
  late HasuraConnect service;
  setUp(() {
    when(httpClient).calls(#close).thenReturn(() {});
    service = HasuraConnect(
      "https://www.youtube.com/c/flutterando",
      interceptors: [cacheInterceptor],
    );
  });

  tearDown(() async {
    //await cacheInterceptor.clearAllCache();
  });

  group("no connection and", () {
    test(" no cache, throws exception", () async {
      final mockResponse = http.Response("", 404);
      when(
        httpClient
      ).calls(#post).withArgs(
        positional: [any],
        named: {
          #body:  any,
          #headers: any
        }
      ).thenAnswer((realInvocation) async => mockResponse);

      when(storage).calls(#containsKey).withArgs(positional: [any])
          .thenAnswer((realInvocation) async => false);

      expect(service.query("query"), throwsException);
    });

    test(" have cache, return cache", () async {
      final cache = {"cache_mock_key": "cache_mock_value"};
      final mockResponse = http.Response("", 404);
      when(
        httpClient).calls(#post).withArgs(
        positional: [any],
        named: {
          #body:  any,
          #headers: any
        }
      ).thenAnswer((realInvocation) async => mockResponse);
      when(storage).calls(#containsKey).withArgs(positional: [any]).thenAnswer((realInvocation) async => true);
      when(storage).calls(#get).withArgs(positional: [any]).thenAnswer((realInvocation) async => cache);

      expect(await service.query("query"), cache);
    });
  });

  group("have connection and", () {
    test("no cache, return real response", () async {
      final realResponse = {"mock_key": "mock_value"};

      when(httpClient).calls(#post).withArgs(
        positional: [any],
        named: {
          #body: any,
          #headers: any
        }
      ).thenAnswer(
        (realInvocation) async => http.Response(jsonEncode(realResponse), 200)
        ,
      );
      when(storage).calls(#containsKey).thenAnswer((realInvocation) async => false);

      expect(await service.query("query"), realResponse);
    });

    test("have cache, return real response", () async {
      final realResponse = {"mock_key": "mock_value"};
      final cache = {"cache_mock_key": "cache_mock_value"};
      //final mockResponse = http.Response("", 200);

      when(
        httpClient
      ).calls(#post).withArgs(
        positional: [any],
        named: {
          #body:  any,
          #headers: any
        }
      ).thenAnswer(
        (realInvocation) async => http.Response(jsonEncode(realResponse), 200),
      );
      when(storage).calls(#containsKey).withArgs(positional: [any]).thenAnswer((realInvocation) async => true);
      when(storage).calls(#get).withArgs(positional: [any]).thenAnswer((realInvocation) async => cache);

      expect(await service.query("query"), realResponse);
    });
  });
}
