import 'package:dartz/dartz.dart';
import 'package:hasura_connect/hasura_connect.dart';

import '../../domain/entities/counter_entity.dart';

abstract class ISubscriptionDatasource {
  Future<Snapshot<CounterEntity>> getCounter();
  Future<Unit> updateCounter(CounterEntity counterEntity);
}