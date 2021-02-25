import 'package:hasura_cache_interceptor/src/cache_interceptor.dart';
import 'package:hasura_cache_interceptor/src/services/storage_service_interface.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:hasura_connect/src/domain/models/query.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

class MockStorageService extends Mock implements IStorageService {}

void main() {
  final storage = MockStorageService();
  late CacheInterceptor cacheInterceptor;
  setUp(() {
    cacheInterceptor = CacheInterceptor(storage);
  });

  tearDown(() async {
   // await cacheInterceptor.clearAllCache();
  });

  group("onError -", () {
    test("Erro genérico", () async {
      when(storage).calls(#containsKey)
          .thenAnswer((realInvocation) async => false);

      final requestMock = Request(url: "", query: Query(document: "query"));
      final error = HasuraRequestError.fromException(
        "Generic Error",
        Exception("Generic Error"),
        request: requestMock,
      );

      final response = await cacheInterceptor.onError(error);

      expect(response, error);
    });
    group("Sem conexão:", () {
      test("Sem cache salvo deve retornar a exceção", () async {
        when(storage).calls(#containsKey).withArgs(positional: [any])
            .thenAnswer((realInvocation) async => false);

        final request = Request(url: "", query: Query(document: "query"));
        final error = HasuraRequestError.fromException(
          "Connection Rejected",
          Exception("Connection Rejected"),
          request: request,
        );

        final response = await cacheInterceptor.onError(error);

        expect(response, error);
      });
      test("Com cache salvo deve retornar o cache", () async {
        final cachedData = {"cache_mock_key": "cache_mock_value"};

        when(storage).calls(#containsKey).withArgs(positional: [any])
            .thenAnswer((realInvocation) async => true);

        when(storage).calls(#get).withArgs(positional: [any]).thenAnswer((realInvocation) async => cachedData);

        final request = Request(url: "", query: Query(document: "query"));
        final error = HasuraRequestError.fromException(
          "Connection Rejected",
          Exception("Connection Rejected"),
          request: request,
        );

        final Response response = await cacheInterceptor.onError(error);

        expect(response.data, cachedData);
      });
    });
  });

  group("onResponse -", () {
    test("Deve salvar o cache", () async {
      final requestMock = Request(
        url: "mock_url",
        query: Query(document: "mock_request_document"),
      );

      final responseMock = Response(
        request: requestMock,
        statusCode: 200,
        data: {"mock_key": "mock_value"},
      );

      final Map cacheMock = {};

      when(storage).calls(#put).withArgs(positional: [any, any]).thenAnswer(
        (realInvocation) async {
          final key = realInvocation.positionalArguments[0];
          final value = realInvocation.positionalArguments[1];
          cacheMock[key] = value;
        },
      );

      await cacheInterceptor.onResponse(responseMock);
      expect(cacheMock, {requestMock.url: responseMock.data});
    });
  });

  group("onSubscription -", () {
    test("Deve mostrar o cache e depois o response original", () async {
      final requestMock = Request(url: "mock_url", query: Query(document: "query"));
      final snapshotMock = Snapshot(query: requestMock.query);
      final key = Uuid().v5(requestMock.url, requestMock.query.toString());
      final Map cacheMock = {key: '{"cache_mock_key": "cache_mock_value"}'};
      final Map responseMock = {"mock_key": "mock_value"};

      when(storage).calls(#containsKey).thenAnswer((realInvocation) async => true);
      when(storage).calls(#get).thenAnswer((realInvocation) async => cacheMock);

      await cacheInterceptor.onSubscription(
        requestMock,
        snapshotMock,
      );

      emitsInAnyOrder([cacheMock, responseMock]);

      snapshotMock.add(responseMock);
    });

    test("Deve salvar o cache", () async {
      final requestMock =
          Request(url: "mock_url", query: Query(document: "query"));
      final snapshotMock = Snapshot(query: requestMock.query);
      final key = Uuid().v5(requestMock.url, requestMock.query.toString());
      final Map cacheMock = {key: '{"cache_mock_key": "cache_mock_value"}'};

      final Map responseMock = {"mock_key": "mock_value"};

      when(storage).calls(#containsKey).withArgs(positional: [any]).thenAnswer((realInvocation) async => true);
      when(storage).calls(#get).withArgs(positional: [any]).thenAnswer((realInvocation) async => cacheMock);

      when(storage).calls(#put).withArgs(positional: [any, any]).thenAnswer(
        (realInvocation) async {
          final key = realInvocation.positionalArguments[0];
          final value = realInvocation.positionalArguments[1];
          cacheMock[key] = value;
        },
      );

      await cacheInterceptor.onSubscription(
        requestMock,
        snapshotMock,
      );
      snapshotMock.listen((_) {});
      snapshotMock.add(responseMock);

      await Future.delayed(Duration(milliseconds: 500));

      expect(cacheMock[key], responseMock);
    });
  });
}
