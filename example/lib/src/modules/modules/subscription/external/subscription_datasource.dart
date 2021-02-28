import 'package:dartz/dartz.dart';
import 'package:example/src/modules/modules/subscription/domain/entities/counter_entity.dart';
import 'package:example/src/modules/modules/subscription/infra/datasource/subscription_datasources.dart';
import 'package:hasura_connect/hasura_connect.dart';

class SubscriptionDatasource implements ISubscriptionDatasource {
  final HasuraConnect hasura_connect;
  SubscriptionDatasource(this.hasura_connect);
  @override
  Future<Snapshot<CounterEntity>> getCounter() async {
    // ignore: close_sinks
    Snapshot response;
    var queryDoc = r'''
          subscription MySubscription($id: Int) {
          new_schema_counter(where: {id: {_eq: $id}}) {
            counter
            id
          }
        }
    ''';
    try {
      response = await hasura_connect.subscription(queryDoc);
    } catch (e) {
      throw Exception('ErrorConnection: $e');
    }

    return response.map((event) {
      CounterEntity counterEntity;
      try {
        counterEntity =
            CounterEntity.fromMap(event['data']['new_schema_counter'][0]);
      } catch (e) {
        throw Exception('Error generate list: $e');
      }
      return counterEntity;
    });
  }

  @override
  Future<Unit> updateCounter(CounterEntity counterEntity) async {
    String queryDoc = r'''
          mutation MyMutation($counter: Int, $id: Int) {
        update_new_schema_counter(where: {id: {_eq: $id}}, _set: {counter: $counter}) {
          affected_rows
          returning {
            counter
            id
          }
          }
        }
    ''';
    try {
      await hasura_connect.mutation(queryDoc, variables: {
        "id": counterEntity.id, "counter": counterEntity.counter
        }..removeWhere((key, value) => value == null)
      );
      return unit;
    } catch (e) {
      throw Exception('ErrorConnection: $e');
    }
  }
}
