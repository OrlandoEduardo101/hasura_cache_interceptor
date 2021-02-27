import 'package:example/src/modules/modules/subscription/domain/entities/counter_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:example/src/modules/modules/subscription/domain/repositories/subscription_repository.dart';

abstract class IUpdateCounter {
  Future<Either<Exception, Unit>> call(CounterEntity counterEntity);
}

class UpdateCounter implements IUpdateCounter {
  final ISubscriptionRepository _repository;

  UpdateCounter(this._repository);
  @override
  Future<Either<Exception, Unit>> call(CounterEntity counterEntity) async {
    return await _repository.updateCounter(counterEntity);
  }
}
