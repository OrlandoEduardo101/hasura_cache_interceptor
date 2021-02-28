import 'package:dartz/dartz.dart';
import 'package:example/src/modules/modules/subscription/domain/entities/counter_entity.dart';
import 'package:example/src/modules/modules/subscription/domain/repositories/subscription_repository.dart';
import 'package:example/src/modules/modules/subscription/infra/datasource/subscription_datasources.dart';
import 'package:hasura_connect/hasura_connect.dart';

class SubscriptionRepository implements ISubscriptionRepository {
  final ISubscriptionDatasource _datasource;

  SubscriptionRepository(this._datasource);
  @override
  Future<Either<Exception, Snapshot<CounterEntity>>> getCounter() async {
    try {
      // ignore: close_sinks
      var result = await _datasource.getCounter();
      return Right(result);
    } catch (e) {
      return Left(Exception('DataSourceError: $e'));
    }
  }

  @override
  Future<Either<Exception, Unit>> updateCounter(CounterEntity counterEntity) async {
    try {
      // ignore: close_sinks
      var result = await _datasource.updateCounter(counterEntity);
      return Right(result);
    } catch (e) {
      return Left(Exception('DataSourceError: $e'));
    }
  }
}
