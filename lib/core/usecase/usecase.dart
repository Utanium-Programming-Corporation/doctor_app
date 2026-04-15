import 'package:dartz/dartz.dart';

import '../error/failures.dart';

typedef FutureResult<T> = Future<Either<Failure, T>>;
typedef StreamResult<T> = Stream<Either<Failure, T>>;

abstract interface class UseCaseWithParams<T, Params> {
  FutureResult<T> call(Params params);
}

abstract interface class UseCaseWithoutParams<T> {
  FutureResult<T> call();
}

abstract interface class StreamUseCaseWithParams<T, Params> {
  StreamResult<T> call(Params params);
}

abstract interface class StreamUseCaseWithoutParams<T> {
  StreamResult<T> call();
}
