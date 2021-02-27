import 'package:dartz/dartz.dart';
import 'package:hasura_connect/hasura_connect.dart';
import '../entities/counter_entity.dart';

abstract class ISubscriptionRepository {
  Future<Either<Exception, Snapshot<CounterEntity>>> getCounter();
  Future<Either<Exception, Unit>> updateCounter(CounterEntity counterEntity);
}