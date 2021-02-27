import 'package:dartz/dartz.dart';
import 'package:hasura_connect/hasura_connect.dart';
import '../entities/counter_entity.dart';
import '../repositories/subscription_repository.dart';

abstract class IGetCounterStream {
  Future<Either<Exception, Snapshot<CounterEntity>>> call();
}

class GetCounterStream implements IGetCounterStream {
  final ISubscriptionRepository _repository;

  GetCounterStream(this._repository);
  @override
  Future<Either<Exception, Snapshot<CounterEntity>>> call() async {
    return await _repository.getCounter();
  }
}
